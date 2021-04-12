
alias opengametunnel='ngrok tls 30000 -hostname=dragonriders.thefae.run'

splitsprite () { convert "$1" -crop "$2"x"$3"@ +repage +adjoin "$4".tile-%d.png }
