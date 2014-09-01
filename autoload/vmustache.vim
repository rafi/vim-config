let s:old_cpo = &cpo
set cpo&vim

let s:tagmap = []

call add(s:tagmap, {"regex": "{{#\\([^{}]\\+\\)}}", "type": "section_start"})
call add(s:tagmap, {"regex": "{{^\\([^{}]\\+\\)}}", "type": "inverted_section_start"})
call add(s:tagmap, {"regex": "{{/\\([^{}]\\+\\)}}", "type": "section_end"})
call add(s:tagmap, {"regex": "{{&\\([^{}]\\+\\)}}", "type": "var_unescaped"})
call add(s:tagmap, {"regex": "{{!\\([^{}]\\+\\)}}", "type": "comment"})
call add(s:tagmap, {"regex": "{{?func:\\(\\(\\\\}\\|\\\\\\|[^}]\\)\\+\\)}}", "type": "function"})
call add(s:tagmap, {"regex": "{{\\([^{}]\\+\\)}}", "type": "var_escaped"})

" TODO: Unescaped variables, inverted sections and partials are not
" suppported, yet

""""""""
" Usage
""""""""

func! vmustache#RenderString(text, data)
	let l:tokens = vmustache#Tokenize(a:text)
	let l:template = vmustache#Parse(l:tokens)
	return vmustache#Render(l:template, a:data)
endfunc

func! vmustache#RenderFile(file, data)
	let l:text = join(readfile(a:file), "\n")
	return vmustache#RenderString(l:text, a:data)
endfunc

"""""""
" Tools
"""""""

let g:vmustache_counters = {}

func! vmustache#InitCounter(name, ...)
	let l:start = 0
	if a:0 > 0
		let l:start = a:1
	endif
	let g:vmustache_counters[a:name] = l:start
	return ""
endfunc

func! vmustache#IncrementCounter(name)
	if !has_key(g:vmustache_counters, a:name)
		call vmustache#InitCounter(a:name)
	endif
	let g:vmustache_counters[a:name] += 1
	return g:vmustache_counters[a:name]
endfunc

"""""""""""""
" Tokenizing
"""""""""""""

func! vmustache#Tokenize(text)

	" TODO: Allow } in script
	let l:regex = "{{[^{}]*}}"

	let l:tokens = []
	let l:lastindex = -1
	let l:hasmore = 1

	let l:matchstart = match(a:text, l:regex, l:lastindex)
	while (l:matchstart != -1)
		let l:match = matchstr(a:text, l:regex, l:lastindex)
		let l:matchend = l:matchstart + strlen(l:match)
		if (l:lastindex != l:matchstart)
			call add(l:tokens, s:ExtractTextToken(a:text, l:lastindex, l:matchstart))
		endif
		call add(l:tokens, s:ExtractTagToken(a:text, l:matchstart, l:matchend))
		let l:lastindex = l:matchend
		let l:matchstart = match(a:text, l:regex, l:lastindex)
	endwhile

	if (l:lastindex < strlen(a:text))
		call add(l:tokens, s:ExtractTextToken(a:text, l:lastindex, strlen(a:text)))
	endif

	return l:tokens
endfunc

func! vmustache#DumpTokens(tokens)
	for token in a:tokens
		echo "Token: " . token["type"]
		echo '"' . token["value"] . '"' . "\n"
	endfor
endfunc

func! s:ExtractToken(text, start, end)
	return strpart(a:text, a:start, a:end - a:start)
endfunc

func! s:ExtractTextToken(text, start, end)
	return s:CreateToken("text", s:ExtractToken(a:text, a:start, a:end))
endfunc

func! s:ExtractTagToken(text, start, end)
	let l:token = s:ExtractToken(a:text, a:start, a:end)
	for l:matcher in s:tagmap
		if l:token =~ l:matcher["regex"]
			let l:matches = matchlist(l:token, l:matcher["regex"])
			return s:CreateToken(l:matcher["type"], l:matches[1])
		endif
	endfor
	throw "Could not identify token '" . l:token . "'"
endfunc

func! s:CreateToken(type, value)
	return {"type": a:type, "value": a:value}
endfunc

""""""""
" Parse
""""""""

func! vmustache#Parse(tokens)
	let l:stack = []
	for token in a:tokens
		call add(l:stack, token)
		if (token["type"] == "section_end")
			let l:stack = s:ReduceSection(l:stack)
		elseif (token["type"] == "comment")
			let l:stack = s:ReduceComment(l:stack)
		elseif (token["type"] == "var_escaped")
			let l:stack = s:ReduceVariable(l:stack)
		elseif (token["type"] == "script")
			let l:stack = s:ReduceFunction(l:stack)
		endif
	endfor
	let l:stack = s:ReduceTemplate(l:stack)
	return l:stack[0]
endfunc

func! s:ReduceSection(stack)
	let l:endtoken = remove(a:stack, -1)
	let l:children = []
	while (!empty(a:stack))
		let l:token = remove(a:stack, -1)
		if (s:SectionMatches(l:token, l:endtoken))
			let l:starttoken = l:token
			break
		endif
		call insert(l:children, l:token)
	endwhile
	if (!exists("l:starttoken"))
		throw "Section missmatch. Missing start tag for '" . l:endtoken["value"] . "'"
	endif
	call add(a:stack, s:CreateSectionNode(l:starttoken, l:children))
	return a:stack
endfunc

func! s:CreateSectionNode(starttoken, children)
	let l:type = ""
	if (a:starttoken["type"] == "inverted_section_start")
		let l:type = "inverted_section"
	else
		let l:type = "section"
	endif
	return {
		\ "type": l:type,
		\ "name": a:starttoken["value"],
		\ "children": a:children}
endfunc

func! s:SectionMatches(starttoken, endtoken)
	return (a:starttoken["type"] == "section_start"
		\ || a:starttoken["type"] == "inverted_section_start" )
		\ && a:starttoken["value"] == a:endtoken["value"]
endfunc

func! s:ReduceVariable(stack)
	let l:token = remove(a:stack, -1)
	let l:variable = s:CreateVariableNode(l:token["value"])
	call add(a:stack, l:variable)
	return a:stack
endfunc

func! s:ReduceFunction(stack)
	let l:token = remove(a:stack, -1)
	call add(a:stack, {
		\ "type": "function",
		\ "content": l:token["value"]})
	return a:stack
endfunc

func! s:CreateVariableNode(name)
	return {"type": "var_escaped", "name": a:name}
endfunc

" TODO: Should we actually keep comments and just not render them?
func! s:ReduceComment(stack)
	call remove(a:stack, -1)
	return a:stack
endfunc

func! s:ReduceTemplate(stack)
	let l:template = s:CreateTemplateNode()
	while (!empty(a:stack))
		call insert(l:template["children"], remove(a:stack, -1))
	endwhile
	call add(a:stack, l:template)
	return a:stack
endfunc

func! s:CreateTemplateNode()
	return {"type": "template", "children": []}
endfunc

func! vmustache#DumpTemplate(template)
	call s:DumpNode(a:template, 0)
endfunc

func! s:DumpNode(node, indent)
	if (a:node["type"] == "template")
		call s:DumpText("Template", a:indent)
		call s:DumpChildren(a:node["children"], a:indent)
	elseif (a:node["type"] == "section")
		call s:DumpText("Section '" . a:node["name"] . "'", a:indent)
		call s:DumpChildren(a:node["children"], a:indent)
	elseif (a:node["type"] == "var_escaped")
		call s:DumpText("Variable '" . a:node["name"] . "'", a:indent)
	elseif (a:node["type"] == "text")
		call s:DumpText("Text '" . a:node["value"] . "'", a:indent)
	endif
endfunc

func! s:DumpText(text, indent)
	echo repeat("  ", a:indent) . a:text
endfunc

func! s:DumpChildren(children, indent)
	let l:indent = a:indent + 1
	for child in a:children
		call s:DumpNode(child, l:indent)
	endfor
endfunc

"""""""""
" Render
"""""""""

func! vmustache#Render(node, data)
	let l:result = ""
	if (a:node["type"] == "template")
		let l:result = l:result . s:RenderBlock(a:node, a:data)
	elseif (a:node["type"] == "section")
		let l:result = l:result . s:RenderSection(a:node, a:data)
	elseif (a:node["type"] == "inverted_section")
		let l:result = l:result . s:RenderInvertedSection(a:node, a:data)
	elseif (a:node["type"] == "var_escaped")
		let l:result = l:result . s:RenderVariable(a:node, a:data)
	elseif (a:node["type"] == "function")
		let l:result = l:result . s:RenderFunction(a:node)
	elseif (a:node["type"] == "text")
		let l:result = l:result . s:RenderText(a:node, a:data)
	else
		throw "Unknown node: " . string(a:node)
	endif
	return l:result
endfunc

func! s:RenderBlock(block, data)
	let l:result = ""
	for child in a:block["children"]
		if (has_key(child, "name") && has_key(a:data, child["name"]) && !empty(a:data[child["name"]]))
			let l:result = l:result . vmustache#Render(child, a:data[child["name"]])
		else
			let l:result = l:result . vmustache#Render(child, [])
		endif
	endfor
	return l:result
endfunc

func! s:RenderSection(section, data)
	let l:result = ""
	if (type(a:data) != 3)
		let l:data = [a:data]
	else
		let l:data = a:data
	endif
	for l:element in l:data
		let l:result = l:result . s:RenderBlock(a:section, l:element)
	endfor
	return l:result
endfunc

func! s:RenderInvertedSection(section, data)
	let l:result = ""
	if (empty(a:data))
		let l:result .= s:RenderBlock(a:section, {})
	endif
	return l:result
endfunc

func! s:RenderVariable(variable, data)
	if (empty(a:data))
		return ""
	endif
	" return "<data>" . a:data . "</data>"
	" return string(a:data)
	return a:data
endfunc

func! s:RenderFunction(script)
	return eval(a:script["value"])
endfunc

func! s:RenderText(node, data)
	" return "<text>" . a:node["value"] . "</text>"
	return a:node["value"]
endfunc

let &cpo = s:old_cpo
