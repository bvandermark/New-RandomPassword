# New-RandomPassword - ReadMe
New-RandomPassword is a PowerShell module designed to generate passwords that are as random as possible. This module features the ability to:

1. Specify the length of the password. The smallest a password can be is 8 characters, the largest is up to your imagination. The default is 13.
2. Need to generate a whole bunch of random passwords really quickly? There's a parameter for that which will make PowerShell generate a new random password however many times you want.
3. Need a basic password without any special characters? The basic parameter will allow you to create random passwords with Uppers, Lowers, and Numbers.
4. Does the program you use only allow for certain special characters? Specify that character list in your call of the command and get randomly generated passwords that match your complexity requirements.
5. Creating a single password to paste somewhere else? There's a parameter that will add the password to your clipboard for you.

## Parameters

1. length - The length of each password generated by this module. Default is 13, minimum is 8.
2. numOfPass - The number of randomly generated password this module will output. Default is 1.
3. basic - Generates a random password without any special characters.
4. specialChars - List of special characters PowerShell will use to generate passwords with. Defaults to !#%^*+-~
5. setClipboard - Adds a single password to the clipboard history.

## Example usage

1. Generates a Random password with the default options.

   New-RandomPassword

2. Generates a Random password without using special characters.

   New-RandomPassword -basic

3. Generates a random password using \#*^.@\ as the special characters

   New-RandomPassword -specialChars "#*^.@"

4. Generates 5, 15 character passwords

   New-RandomPassword -length 15 -numOfPass 5