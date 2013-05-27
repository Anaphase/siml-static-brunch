## siml-static-brunch
Adds static [SIML](https://github.com/padolsey/SIML) support to [Brunch](http://brunch.io).

## How it Works
siml-static-brunch searches the `templates.joinTo` directory and compiles any file with the `.siml` extension, excluding the assets directory. The compiled HTML is placed in the public folder in a directory matching wherever the `.siml` file was located within the `templates.joinTo` directory.

## Usage
Install the plugin via npm with `npm install --save siml-static-brunch`.

Or, do manual install:

* Add `"siml-static-brunch": "x.y.z"` to `package.json` of your Brunch app. Pick a plugin version that corresponds to your minor (y) Brunch version.
* If you want to use git version of plugin, add `"siml-static-brunch": "git+ssh://git@github.com:Anaphase/siml-static-brunch.git"`.

## Sample Brunch config.coffee
```coffee-script
exports.config =
  
  files:
    
    # other config stuff here
    
    templates:
      defaultExtension: 'siml'
      joinTo:
        'siml-static-brunch': /^app/ # dirty hack for SIML compilation; key can be whatever you want as it will be deleted by siml-static-brunch
  
  # you can turn pretty print on here
  plugins:
    siml:
      generator: 'angular' # default is 'html5'
      pretty: yes # default is no
```

## License

The MIT License (MIT)

Copyright (c) 2013 Colin Wood

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
