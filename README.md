# ufw-parser
Parse UFW logs 
Group and Sort them by variable counts with parameter

You can pass the min count matches for display by ```ufw-parser.sh 30``` or any other digit - default will be top ten counts

I prefer to use it inside my .bashrc as ```function ulog() {...} ```
Now only ```ulog 30``` needed 
Example Output:
```
# ulog 30
Group: SRC=138.185.108.178, Count: 616, Entry: May      15
Group: SRC=195.154.199.60, Count: 401, Entry: May       15
Group: SRC=35.192.179.181, Count: 217, Entry: May       12
Group: SRC=154.213.17.252, Count: 33, Entry: May        12       
```
# ulog2 now compares with ufw blocked status and has a table view
```
# ulog2
Group                Count      Date Time            Port       Status
-----                -----      ---------            ----       ------
115.187.32.37        337        May 19 19:10:00      3389        already blocked
109.123.240.84       44         May 20 18:30:18      25565       already blocked
135.181.149.138      41         May 20 18:36:18      25565       already blocked
181.65.169.150       21         May 20 18:39:25      3389        already blocked
41.78.188.73         17         May 20 18:09:38      3389        already blocked
185.136.205.116      15         May 20 14:57:38      3389        already blocked
109.164.106.171      15         May 20 18:12:58      25565      
104.247.120.8        14         May 20 19:39:03      3389       
219.157.116.121      12         May 20 19:43:50      3389       
167.250.160.135      12         May 20 12:57:18      3389       
80.66.76.123         11         May 20 13:37:17      3389      
``` 
