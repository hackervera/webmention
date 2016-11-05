#Webmention


This library is alpha quality so I'm not publishing to hex yet.  
To use this library, put `{:webmention, github: "tjgillies/webmention"}` in your deps array.  
This library implements the [IndieWeb Webmention](https://indieweb.org/Webmention) and [IndieWeb Private Webmention](https://indieweb.org/Private_Webmention) specifications.

## Example app
I have an [example app available to examine](http://github.com/tjgillies/indie) that uses this library.

## In your Phoenix router put the following at the top.  

```
use Webmention.Router, %{
  root: :indie,
  webmention_callback :callback,
  token_function: :token_function
}
```

This will add a number of routes under the 'indie' namespace. The 'indie' part is configurable to whatever you want.  The current routes in this library are `/indie/webmention` for verifying webmentions and `/indie/token` for exchanging a private webmention code for a token.

### Callback function
After you set that up, also add the following to your Phoenix router.  

```
def callback(content) do
  # Do something with content
end
```

Once the webmention is sucessfully verified, the content from the source site will be returned in the content variable.  
You can use whatever function name you want for the callback, just be sure to change it in the config map.  

### Token function
The token function is for generating a token for private webmention based on a passed in code from the requester.  
Here is an example function.  

```
def token_function(code) do
  # Check to see if code is valid then return a token
  "123"
end
```
## In a controller
In the controller that controlls access to private data you will need to add `plug Webmention.Authorize, SomeModule.some_function`. This will ensure your site throws a 401 unless passed a valid token to the endpoint. This function should return the expected token for this request. It doesn't take any arguments.

You need to add `plug :put_webmention_header` to any pipeline/controller where you want to have a webmention header injected.
