## Checks Powershell Version
$PSVer = $PSVersionTable.psversion.Major;

## API url and Developer token. Obtain one at http://diffbot.com/pricing/
$urlAPI = "http://api.diffbot.com/v2/";
$token = “DIFFBOT_TOKEN”;

## Explicitly import .Net Assembly which will allow url encoding and conversion of strings to JSON for PS 2
Add-Type -AssemblyName System.Web;   

function Get-DiffBot {
<# 
 .SYNOPSIS
  Calls a variety of DiffBot APIs
  
 .DESCRIPTION
  Usage: run import-module $PathToThisFile, ie. import-module .\DiffBot.psm1 or create DiffBot directory in C:\Windows\System32\WindowsPowerShell\v1.0\Modules, place DiffBot.psm1 there and run import-module DiffBot. 
  You will then be able to call Get-DiffBot cmdlet as follows:
  Get-DiffBot $UrlToDiffBotify $TypeOfApi $Fields(optional) $Timout(optional).
  Get-DiffBot will return a JSON object if successful for PS3+ or a hashtable for PS2. $Null will be returned if there is an error.
  Requires Powershell 2 or higher and supports -Verbose.
  
 .EXAMPLE 
  With explicitly stated parameters
  Get-DiffBot -url http://www.hachettebookgroup.com/customer_faqs.aspx -api analyze
 
 .EXAMPLE 
  Without explicitly stated parameters
  Get-DiffBot http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/ article
  
 .EXAMPLE 
  Without explicitly stated parameters and with specified fields
  Get-DiffBot http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/ article "date,author,tags"
  
 .EXAMPLE
  Without explicitly stated parameters and with specified fields and timeout
  Get-DiffBot http://www.xconomy.com/san-francisco/2012/07/25/diffbot-is-using-computer-vision-to-reinvent-the-semantic-web/ article "date,author,tags" 10000
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true,HelpMessage="Enter URL to DiffBotify")][string]$url ,
		[Parameter(Mandatory = $true,HelpMessage="Enter type of API to call ie. Analyze, Product, Article etc")][string]$api,
		[Parameter(Mandatory = $false)][string]$fields,
		[Parameter(Mandatory = $false)][int]$timeout = 5000
		)
	$request = $null
	
	## encode url
	$encodedUrl = [System.Web.HttpUtility]::UrlEncode($url);
	
	## build a full Url to call
	$constructedUrl = $urlAPI + $api + "?format=json`&tags=true`&" + "token=" + $token + "`&url=" + $encodedUrl + "`&fields=" + $fields + "`&timeout=" + $timeout;
	
	try{		
		## Call DiffBot
		Write-Verbose ("Calling URL:`r`n" + $constructedUrl);
		$request = callDiffBot $constructedUrl;	
		}
	catch{
	
		## catch error and produce a meanigful message
		Write-Host -ForegroundColor Red ("Tried calling:`r`n" + $constructedUrl + "`r`nBut there was an error and nothing will be returned..");
		Write-Host -ForegroundColor Red ($_.Exception.Message);		
		}		
	return $request;
}

## A helper function to work work around lack of Invoke-RestMethod in PS2
function callDiffBot ($restURL){
	if($PSVer -lt 3){
		## create wget client and converts output string to a hashtable if PS2
		$wc = new-object System.Net.WebClient;
		Add-Type -AssemblyName System.Web.Extensions;
		$serialiser = New-Object System.Web.Script.Serialization.JavaScriptSerializer;
		return $serialiser.DeserializeObject($wc.downloadString($restURL));
	}
	else{
		## PS3 version of above
		return Invoke-RestMethod $restURL ;		
	}
}

