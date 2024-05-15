# ufw-parser
Parse UFW logs and Sort them by variable counts

You can pass the min counts for display by ```ufw-parser.sh 30``` or any other digit

I prefer to use it inside my .bashrc as ```function ulog() {...} ```
Now only ```ulog 30``` needed 
Example Output:
```
# ulog 30
Group: SRC=138.185.108.178, Count: 616, Entry: May      15      SRC=138.185.108.178DPT=3389
Group: SRC=195.154.199.60, Count: 401, Entry: May       15      SRC=195.154.199.60DPT=25565
Group: SRC=35.192.179.181, Count: 217, Entry: May       12      SRC=35.192.179.181DPT=22
Group: SRC=154.213.17.252, Count: 33, Entry: May        12      SRC=154.213.17.252DPT=3389
 
```
