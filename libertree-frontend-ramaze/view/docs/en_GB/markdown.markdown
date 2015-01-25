You can style text on Libertree with Markdown syntax.

## Italics 
>_\*italic text\*_ or *\_italic text\_*

## Bold 
>\*\*__bold text__\*\* or \_\_**bold text**\_\_

## Bold + Italics
> ___\*\*\*bold and italic text\*\*\*___

## Links
<div class="example"><pre>
>[link text here]\(www.example.org)
</pre></div>

[link text here]\(www.example.org)

## Images
<div class="example"><pre>
>![image name]\(www.example.org/image.jpg)
</pre></div>

![image name](https://oak.elephly.net/themes/oak/images/logo.png)

## Image + Link
<div class="example"><pre>
>[ ![image name]\(www.example.org/image.jpg)] \(www.example.org)
</pre></div>

[![image name](https://oak.elephly.net/themes/oak/images/logo.png)](www.example.org)


# Libertree-flavoured markdown

## Preformatted blocks

<div class="example"><pre>
This is an ASCII GNU by Martin Dickopp

~~~
  ,= ,-_-. =.
 ((_/)o o(\_))
  `-'(. .)`-'
      \_/
~~~
</pre></div>

This will render like this:

This is an ASCII GNU by Martin Dickopp

~~~
  ,= ,-_-. =.
 ((_/)o o(\_))
  `-'(. .)`-'
      \_/
~~~


## Hidden blocks

<div class="example"><pre>
I watched a movie.  It was great!

?> Especially when the bear appeared out of nowhere
?> and ate all the honey.
</pre></div>


I watched a movie.  It was great!

?> Especially when the bear appeared out of nowhere
?> and ate all the honey.


## HTML5 Videos

<div class="example"><pre>
%[Short description](http://example.com/video.ogv)
</pre></div>

%[Richard Stallman's talk at TEDx](http://audio-video.gnu.org/video/TEDxGE2014_Stallman05_HQ.ogg)


## HTML5 Audio

<div class="example"><pre>
~[Short description](http://example.com/music.ogg)
</pre></div>


~[Short description](http://radioserver1.delfa.net:80/64.opus)


## Footnotes

<div class="example"><pre>
This is a sentence with a footnote[^1].
This is a another sentence.

[^1]: This is the footnote.
</pre></div>


This is a sentence with a footnote[^1].
This is a another sentence.

[^1]: This is the footnote.
