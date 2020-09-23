## Original thread:
How to encrypt a previous sqlite database? 
https://github.com/davidmartos96/sqflite_sqlcipher/issues/20

I have followed all the instructions from this video:
https://www.youtube.com/watch?v=SFHGeetZ0po

## Setp 1
Clone the source code from sqlite cipher:
`git clone https://github.com/sqlcipher/sqlcipher.git`

## Step 2
Download the Active TCL from: https://www.activestate.com/products/tcl/downloads/

## Step 3
Download Windows Open SSL from https://slproweb.com/products/Win32OpenSSL.html
Win64 OpenSSL v1.1.1g EXE 

## Setp 4
Edit the Makefile.smc from sqlcipher repository that was cloned:
Change 
`TCC = $(TCC) -DSQLITE_TEMP_STORE=1
`
to
`TCC = $(TCC) -DSQLITE_TEMP_STORE=2 -DSQLITE_HAS_CODEC -I"C:\Program Files\OpenSSL-Win64\include"`

Search for `LTLIBS = $(LTLIBS) $(LIBICU)` and insert atfer the tag `"# <</mark>>"`  the code:

    LTLIBPATHS = $(LTLIBPATHS) /LIBPATH:"C:\Program Files\OpenSSL-Win64\lib\VC\static"
    LTLIBS = $(LTLIBS) libcrypto64MT.lib libssl64MT.lib ws2_32.lib shell32.lib advapi32.lib gdi32.lib user32.lib crypt32.lib

## Step 5
Open  x64 Native Tools Command Prompt from Vs 2019 (Start menu / Visual Studio  2019);
Navigate to where you clone the sqlcipher repository. In my case:
cd C:\Repositorios\sqlitecipher
Compile the file Makefile typing the command:
`nmake /f Makefile.msc`

## Step 6 (if you got an error on Step 5)
When I try to compile on Windows 10 using  x64 Native Tools Command Prompt from Vs 2019 (`nmake /f Makefile.msc`) , I've got an error of missing `stdio.h`.

So I had to download the Wnidows 10 SDK usign Visual Studio Installer.

## Step 7: Verify
After finish the compilation, it will be generated an 'sqlite3.exe' file inside the folder. On the same command prompt, run 'sqlite3.exe' and see if the message SQLCipher Version XXXXX Connected to in memory transient database' appears.

## Step 8: 
After compilation , I added the path of sqlite3.exe to PATH environment system PATH.

## Step 9: Bash Script
Then I made a separeted folder with my orignial sqlite database unencripted, and used this bash script from @davidmartos96 to convert the original database into a encrypted one.

    #!/bin/bash
    if [ -z "$1" ]
      then
        echo "No argument supplied"
        exit
    fi 
    
    echo "Encrypting $1" 
    echo "ATTACH DATABASE 'encrypted.db' AS encrypted KEY '123456ABC'; SELECT sqlcipher_export('encrypted'); DETACH DATABASE encrypted;" | sqlite3 $1
    
    echo
    echo "Copying to Flutter project"
    #rm C:/app_mobile/assets/databases/original_database.db
    
    cp encrypted.db C:/app_mobile/assets/databases/original_database.db
    #rm original_database.db
    
    echo "Done."

I saved this code into a file called "bash_build.sh".

## Step 10: Convert the database
I put a copy of the original database on the same folder as bash_build.sh. Make sure you have a backup of your database file because this file is deleted after encrypted.

Then, I used Git Bash (inside the same folder where bash_build.sh is located) to run the bash script:
`./bash_build.sh myDatabase.db`

## Conclusion
I'm not expert on bash script or encryption, but I got this working with some help.
I've tested the encripted file on Android Emulator and physical devices using Flutter and  sqflite_sqlcipher package, and works fine. 
If I pass a wrong password or any password at all, my app is not able to read the database.

If you want to open your encrypted sqlite file on Windows, download a version of SQLiteBrowser https://github.com/sqlitebrowser/sqlitebrowser/releases.

Also some usefull link (also posted on original thread): https://discuss.zetetic.net/t/how-to-encrypt-a-plaintext-sqlite-database-to-use-sqlcipher-and-avoid-file-is-encrypted-or-is-not-a-database-errors/868

This repository has all files that was used: bash script and all compiled sqlitecipher, so you can just use it directly as you want.
They helped me, so I hope this helps you.
