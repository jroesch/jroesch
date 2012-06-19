#!/bin/bash
ghc main.hs -o hakyll
./hakyll clean
./hakyll build
cp -r ./_site/* ./../jroesch.github.com
cd jroesch.github.com
git add *
git commit -am "deploying site from git://github.com/jroesch/jroesch.git"
git push origin master