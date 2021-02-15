# ProBrws (Processing Browser and Web Server)
This is a custom Browser and Web Server with it's own dedicated markup language called PML.

## Browser Usage
The browser is really simple, you just have a textbox where you can type the adress of the page.

You can open a local .pml file by writing `file://` followed by the path to the `.pml`.  
Or you can connect to a WebServer by specifying it's host. The host can be ethier an `IP` or `localhost`.

## WebServer Usage
To use the webserver you just have to put your `index.pml` file in the same folder as the server.  
It's important it's name is exactly **index.pml** or it won't load. Images need to be specified inside the `img` folder.

## Targeted features are:
- ~~Load PML pages locally~~ | Done
- ~~Load PML imges across the internet using the WebServer~~ | Done
- Image transfer across the web | Almost done, there are some issues
- Custom domain name system | Todo

### *Maybe I implement these:*
- Extended full PML lang (more tags, links, animations)
- Full style and script support
- Video transfer

## PML Documentation

The actual available tags are the following:

**Background Color**  
`<background R;G;B>` R, G, B going from 0 to 255.

**Global Margin**  
`<magrin X;Y>` X, Y in px.

**Text**  
`<text Sample Text;X;Y>` X and Y are optional margin parameters.

**Image**  
`<img src;X;Y>` src is the path to the image, X and Y are optional margin parameters.

**Newline**  
`<nl ;>`

Check out `page.pml` in the browser folder to see an example.
