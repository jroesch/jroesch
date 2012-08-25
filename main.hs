{-# LANGUAGE OverloadedStrings #-}
import Control.Arrow ((>>>))
import Prelude hiding (id)
import Control.Category (id)
import Control.Arrow ((>>>), (***), arr)
import Data.Monoid (mempty, mconcat)
import Hakyll

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler
        
    match "css/*" $ do
        route idRoute
        compile compressCssCompiler
        
    match "templates/*" $ compile templateCompiler
    
    -- Move homepage to blog listing vs. about me?
    {- match "index.html" $ do
        route idRoute
        compile $ readPageCompiler
            >>> arr applySelf
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler -}

    match "about.html" $ do
        route $ customRoute $ \_ -> "index.html"
        compile $ readPageCompiler
            >>> arr applySelf
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler 
            
    match "resume.html" $ do
        route idRoute
        compile $ readPageCompiler
            >>> arr applySelf
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

    match "posts/*" $ do
        route   $ setExtension ".html"
        compile $ pageCompiler
            >>> applyTemplateCompiler "templates/post.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler
    
    match  "posts.html" $ route idRoute
    create "posts.html" $ constA mempty
        >>> arr (setField "title" "All posts")
        >>> requireAllA "posts/*" addPostList
        >>> applyTemplateCompiler "templates/postList.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler
    
    match "404.html" $ do
        route idRoute
        compile $ pageCompiler
            >>> applyTemplateCompiler "templates/default.html"
  
addPostList :: Compiler (Page String, [Page String]) (Page String)
addPostList = setFieldA "posts" $
    arr (reverse . sortByBaseName)
        >>> require "templates/postItem.html" (\p t -> map (applyTemplate t) p)
        >>> arr mconcat
        >>> arr pageBody