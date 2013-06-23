fs = require 'fs'
siml = require 'siml'
sysPath = require 'path'
mkdirp  = require 'mkdirp'

write = (path, content) ->
  return if not content?
  dir = sysPath.dirname path
  mkdirp dir, '0775', (err) ->
    throw err if err?
    fs.writeFile path, content, (err) -> throw err if err?

module.exports = class SIMLStaticBrunch
  
  brunchPlugin: yes
  type: 'template'
  extension: 'siml'
  
  constructor: (config) ->
    @public = config.paths.public
    @junkFile = (Object.keys config.files.templates.joinTo)[0]
    @rootDir = config.files.templates.joinTo[@junkFile]
    
    # options
    @pretty = if !config.plugins?.siml?.pretty? then yes else config.plugins?.siml?.pretty 
    @generator = config.plugins?.siml?.generator
    
    # default to html5 generator if none is specified
    @generator = 'html5' unless @generator
  
  # Basically does nothing except test compilation and throw an error if compilation fails
  compile: (data, path, callback) ->
    
    try
      
      content = siml[@generator].parse data, { pretty: @pretty }
      
      file = @public + path.replace @rootDir, ''
      file = file[...-@extension.length] + 'html'
      
      write file, content
      
    catch ex
      error = "Error: #{ex.message}"
      if ex.type
        error = ex.type + error
      if ex.filename
        error += " in '#{ex.filename}:#{ex.line}:#{ex.column}'"
      
    finally
      callback error
  
  # Deletes the left over junk file (hacky workaround for static pages)
  onCompile: (compiled) ->
    
    # delete the junk file
    fs.unlink sysPath.normalize @public + sysPath.sep + @junkFile
