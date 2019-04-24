paths = [
  """M40.936,0C31.91,0,23.812,3.958,18.27,10.227c-5.781,0.615-12.91-0.888-18.156-6.496
  c0,8.808,4.914,14.042,11.761,18.126c-0.769,2.666-1.189,5.48-1.189,8.394"""
  [\L, 71.187, 30.251, \C, 71.187, 13.544, 57.643, 0, 40.936, 0]
  [\L, 40.936, 60.502, \c, 16.707, 0, 30.251, -13.544, 30.251, -30.251]
  [\L, 10.685, 30.251, \c, 0, 16.707, 13.544, 30.251, 30.251, 30.251]
]

get-bubble = (w, h) ->
  [w,h] = [w - 71, h - 61]
  [p1,p2,p3] = [1,2,3].map -> JSON.parse(JSON.stringify(paths[it]))
  [1,4,6,8].map -> p1[it] += w
  p2.1 += w
  p2.2 += h
  p3.2 += h
  d = (paths.0 + p3.join(' ') + p2.join(' ') + p1.join(' '))
  ow = 71 + w
  oh = 61 + h
  out = """
  <?xml version="1.0"?>
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #ow #oh" style="width:#{ow}px;height:#{oh}px">
    <path d="#d" fill="white"/>
  </svg>
  """
  out = "data:image/svg+xml,#{encodeURIComponent(out)}"

  return out

Array.from(document.querySelectorAll('.bubble')).map (n) ->
  box = n.getBoundingClientRect!
  n.style.backgroundImage = "url(#{get-bubble box.width, box.height})"

bubblify = (n) ->
  box = n.getBoundingClientRect!
  n.style.backgroundImage = "url(#{get-bubble box.width, box.height})"

document.querySelector(\#input-send).addEventListener \click, ->
  talk = document.querySelector('.talk').cloneNode true
  talk.setAttribute \id, null
  conv = document.querySelector('.content')
  name = talk.querySelector \.name
  avatar = talk.querySelector \.avatar
  time = talk.querySelector \.time
  bubble = talk.querySelector \.bubble
  [h,m] = [(new Date!getHours!), (new Date!getMinutes!)].map -> if "#it".length < 2 => "0#it" else "#it"
  time.innerText = "#h:#m PM"
  name.innerText = document.querySelector(\#input-name).value or "Unnamed"
  bubble.innerText = document.querySelector(\#input-msg).value or "..."
  cj = document.querySelector(\#check-join)
  if cj.checked =>
    info = document.querySelector('#info-sample').cloneNode true
    info.setAttribute \id, ''
    info.childNodes.0.innerText = "#{name.innerText} joined the group."
    conv.appendChild info
  conv.appendChild talk
  if document.querySelector('#input-avatar .avatar.active') =>
    avatar.style.backgroundImage= "url(avatar/#{that.getAttribute(\data-idx)}.jpg)"
  bubblify bubble

document.querySelector(\#input-avatar).addEventListener \click, (e) ->
  if !e.target or !e.target.getAttribute => return
  idx = e.target.getAttribute(\data-idx)
  if document.querySelector('#input-avatar .avatar.active') => that.classList.remove \active
  if idx => e.target.classList.add \active

document.querySelector(\#group-name).addEventListener \keyup, (e) ->
  document.querySelector('.head .title').innerText = @value
