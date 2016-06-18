function GetRandomNumber {
    param (
		$max,
		$rnd
	)
    
    $maxGeneratedNumber = 256
    if ($max -gt $maxGeneratedNumber) {
        throw "Cannot generate a number over $maxGeneratedNumber"
    }

    $bytes = New-Object "System.Byte[]" 1
    
    #biasCount is the amount of numbers that appear one more time than all the others, which reduces the randomness of the generated number
    $biasCount = ($maxGeneratedNumber) % $max

    #we will throw away anything over the maxSafeNumber so that all numbers have an equal chance
    $maxSafeNumber = $maxGeneratedNumber - $biasCount

    while ($true) {
        $rnd.GetBytes($bytes)
        $number = $bytes[0]
        if ($number -lt $maxSafeNumber) {
            return $number % $max
        }
    }
}
function New-RandomPassword{
        param(
             [int]$length=13,
             [int]$numOfPass=1,
             [switch]$basic,
             [string]$specialChars="!#%^*+-~",
             [bool]$setClipboard=$true
         )

    if($length -lt 8){"Sorry Charlie. Password length must be longer than 8";$length=8}
    if($numOfPass -lt 1){"Trying to create an infinite loop are we...";$numOfPass=1}

    $charsToUse = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $testForLower = [regex]"[a-z]"
    $testForUpper = [regex]"[A-Z]"
    $testForNumber = [regex]"[0-9]"

    if(-not $basic){#$regexForSpecialChar=$regexForNumber}
        $charsToUse += $specialChars
        $regexForSpecialChar = "["
        [System.Text.Encoding]::ASCII.GetBytes($specialChars) | %{$regexForSpecialChar += "\x{0:X2}" -f $_}
        $regexForSpecialChar += "]"
        $testForSpecialChar = [regex]$regexForSpecialChar
    }
    
    $count=0
	$rnd = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

    do{
        do{
            $lowerPresent=$false;$upperPresent=$false;$numPresent=$false;$specialPresent=$false
            $pw = $null
            for($i=0;$i -lt $length;$i++){
				$RandomNumber = GetRandomNumber -max $charsToUse.Length -rnd $rnd
				$pw += $charsToUse[$RandomNumber]
            }
            $lowerPresent = $pw -match $testForLower;$upperPresent = $pw -match $testForUpper;$numPresent = $pw -match $testForNumber
            if(-not $basic){$specialPresent = $pw -match $testForSpecialChar}else{$specialPresent = $true}
        }until($lowerPresent -and $upperPresent -and $numPresent -and $specialPresent)
        $pw
        $count++
    }until($count -eq $numOfPass)
    if($setClipboard -and ($numOfPass -eq 1)){
        if($PSVersionTable.PSVersion.Major -ge 5){Set-Clipboard $pw}
        else{Add-Type -AssemblyName System.Windows.Forms;[Windows.Forms.Clipboard]::SetText($pw)}
    }
}
Export-ModuleMember -Function New-RandomPassword