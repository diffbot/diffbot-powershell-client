# Diffbot API Powershell client

## Preface

This module allows to call DiffBot APIs from the command line and operate on output with all of the Powershell's flexibility. The module supports common parameters and you can get a man page by running get-help Get-DiffBot.


## Installation

1. Obtain a developer token from http://diffbot.com/
2. Open DiffBot.psm1 and change line 6 to your generated token
	
	$token = "DIFFBOT_TOKEN";
	

Next, create DiffBot directory in C:\Windows\System32\WindowsPowerShell\v1.0\Modules and place DiffBot.psm1 there.
You will then be able to to run 
```powershell
	import-module DiffBot
```	
Alternatively you can  run 
```powershell
	import-module C:\somepath\DiffBot.psm1
```	
where C:\somepath\DiffBot.psm1 is path to your newly downloaded module.



## Configuration

That's it :)

## Usage

### 

Assuming that you followed above instructions you can now use the new Get-DiffBot cmdlet. 

Syntax is as follows 
```powershell
    Get-DiffBot [-url] <String> [-api] <String> [[-fields] <String>] [[-timeout] <Int32>] [<CommonParameters>]
```
with -url and -api being required parameters ie.
```powershell
	Get-DiffBot -url http://www.hachettebookgroup.com/customer_faqs.aspx -api analyze
```
with result
```
title          : Customer FAQs - Hachette Book Group                              
type           : faq                                                              
resolved_url   : http://www.hachettebookgroup.com/customer-faqs/                  
human_language : en                                                               
url            : http://www.hachettebookgroup.com/customer_faqs.aspx              
```

-url and -api are positional parameters so you can run the following
```powershell
	Get-DiffBot http://www.hachettebookgroup.com/customer_faqs.aspx  analyze
```
Valid APIs are: article, frontpage, image, product, analyze ie.

```powershell
Get-DiffBot http://www.hachettebookgroup.com/customer-faqs/ article
Get-DiffBot http://www.hachettebookgroup.com/customer-faqs/ image
Get-DiffBot http://www.hachettebookgroup.com/customer-faqs/ frontpage
Get-DiffBot http://www.hachettebookgroup.com/customer-faqs/ product
Get-DiffBot http://www.hachettebookgroup.com/customer-faqs/ analyze
```

Here is an example calling article API and requesting only 2 fields: images and supertags
```powershell
Get-DiffBot http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/ article -fields "images,supertags"
```
resulting
```
tags      : {Semantic Web, AOL, Computer vision, Technology}                      
author    : Wade Roush                                                            
images    : {@{primary=true; caption=Diffbot; url=http://www.xconomy.com/wordpres 
            s/wp-content/images/2012/07/diffbot-reclining-220x146.jpg},           
            @{caption=NPR's top news page as interpreted by Diffbot; url=http://w 
            ww.xconomy.com/wordpress/wp-content/images/2012/07/Screen-Shot-2012-0 
            7-25-at-9.13.27-AM-300x332.png}, @{caption=Diffbot robot; url=http:// 
            www.xconomy.com/wordpress/wp-content/images/2012/07/12-220x265.png}}  
date      : Wed, 25 Jul 2012 07:00:00 GMT                                         
supertags : {@{id=29123; positions=System.Object[]; name=Semantic Web;            
            score=0.9; contentMatch=1; categories=; type=1; senseRank=1;          
            depth=0.5882352941176471; variety=0.7283018867924529}, @{id=1397;     
            positions=System.Object[]; name=AOL; score=0.7; contentMatch=1;       
            categories=; type=1; senseRank=1; depth=0.5882352941176471;           
            variety=0.4830188679245283}, @{id=6596; positions=System.Object[];    
            name=Computer vision; score=0.7; contentMatch=0.9172413793103449;     
            categories=; type=1; senseRank=1; depth=0.6470588235294117;           
            variety=0.7358490566037736}, @{id=29816; positions=System.Object[];   
            name=Technology; score=0.7; contentMatch=1; categories=; type=1;      
            senseRank=1; depth=0.7647058823529411; variety=0.31320754716981136}}  
type      : article                                                               
url       : http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-comp 
            uter-vision-to-reinvent-the-semantic-web/                             
```

### Error handling

If API call fails a meanigful error message will be outputed to the console rather than throwing an error
```
Tried calling:                                                                
http://api.diffbot.com/v2/adsasd?format=json&tags=true&token=...&url=http%3a%2f%2fwww.gogos.com&fields=&timeout=5000                        
But there was an error and nothing will be returned..                         
The remote server returned an error: (500) Internal Server Error.             
```

## Discussion

### Response handling

If you use Powershell 3 or higher the returned response will be of JSON/PSCustomObject type, a hashtable if you are running Powershell 2 which
you can pipe or operate on as required.

-Initial commit by Rafal Jankowicz-
