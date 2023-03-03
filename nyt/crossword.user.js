// ==UserScript==
// @name         NYT_CROSSWORD_FIXES
// @namespace    http://tampermonkey.net/
// @version      0.1.0
// @description  New york times crossword site fixes
// @author       ryan.mcnamara
// @match        https://*.nytimes.com/*
// @grant        none
// ==/UserScript==
// https://gist.github.com/samsungstark/7440c802b89f9ed413631b84cfb06cfe/edit

setTimeout(function(){
    document.getElementById("boardTitle").remove()
    document.getElementById("js-global-nav").remove()
    document.getElementsByClassName("top-sale-banner")[0].remove()
},2000)
