# ufw-parser
Parse UFW logs 
Group and Sort them by variable counts with parameter

You can pass the min count matches for display by ```ufw-parser.sh 30``` or any other digit - **default will be top ten counts**

I prefer to use it inside my .bashrc as ```function ulog() {...} ```
Now only ```ulog 30``` needed 
Example Output:
# ulog shows all ips which have been blocked "n" times
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
# ulog3 like ulog2 + ability to block all unblocked
```
ulog2 28
Group                Count      Date Time            Port       Status
-----                -----      ---------            ----       ------
115.187.32.37        337        May 19 19:10:00      3389        already blocked
153.35.194.35        65         May 25 09:34:17      3389        already blocked
109.123.240.84       44         May 20 18:30:18      25565       already blocked
31.47.58.14          43         May 25 08:39:39      3389        already blocked
117.131.5.142        43         May 25 10:23:43      3389        already blocked
103.211.38.122       42         May 22 22:15:26      3389        already blocked
135.181.149.138      41         May 20 18:36:18      25565       already blocked
74.94.101.106        36         May 25 05:08:10      3389        already blocked
80.66.76.133         34         May 25 06:43:23      3389        already blocked
167.250.160.135      34         May 23 21:09:19      3389        already blocked
80.66.76.125         32         May 25 11:37:00      3389        already blocked
80.66.76.131         31         May 25 09:24:18      3389        already blocked
41.207.248.204       30         May 25 11:16:37      22         
190.219.13.26        30         May 25 09:51:00      3389       
104.247.120.8        30         May 21 07:03:24      3389        already blocked
45.205.2.16          29         May 25 05:13:58      3389       

The following IPs are not blocked yet and will be blocked:
41.207.248.204
190.219.13.26
45.205.2.16
Do you want to block these IPs? (y/n):
```
# ulog4 now selectable IP Blocking based on Dialog

![image](https://github.com/tamer73/ufw-parser/assets/14232077/81bbb452-c5db-4d65-8832-0e6fb704b3d2)

