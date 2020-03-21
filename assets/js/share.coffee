isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)

export default
  url: (url) ->
    link = document.createElement("a")

    if isMobile
      base = "whatsapp://send?text="
      link.setAttribute("data-action", "share/whatsapp/share")
    else
      base = "https://web.whatsapp.com/send?text="
      link.setAttribute("target", "_blank")

    link.setAttribute("href", base + escape(url))
    link.setAttribute("style", "display:none")
    document.body.appendChild(link)

    link.click()
