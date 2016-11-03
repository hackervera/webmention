Webmention
==========

This library is alpha quality so I'm not publishing to hex yet.  
To use this library, put `{:webmention, github: "tjgillies/webmention"}` in your deps array.  
In your Phoenix router put the following at the top.  

```
use Webmention.Router, %{
  root: :indie,
  webmention_callback :callback
}
```

This will add a route called `/indie/webmention` to your site. The 'indie' part is configurable to whatever you want.  
After you set that up, also add the following to your Phoenix router.  

```
def callback(content) do
  # Do something with content
end
```

Once the webmention is sucessfully verified, the content from the source site will be returned in the content variable.  
You can use whatever function name you want for the callback, just be sure to change it in the config map.  
You need to add `plug :put_webmention_header` to any pipeline where you want to have a discoverable webmention.
