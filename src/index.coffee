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

module.exports = class SIMLCompiler
  
  brunchPlugin: yes
  type: 'template'
  extension: 'siml'
  
  constructor: (config) ->
    @public = config.paths.public
    @junkFile = (Object.keys config.files.templates.joinTo)[0]
    @rootDir = config.files.templates.joinTo[@junkFile]
    @pretty = !!config.plugins?.siml?.pretty
    @generator = config.plugins?.siml?.generator
    
    # default to html5 generator if none is specified
    @generator = 'html5' if @generator isnt 'html5' and @generator isnt 'angular'
  
  # Basically does nothing except test compilation and throw an error if compilation fails
  compile: (data, path, callback) ->
    
    try
      content = siml[@generator].parse data, { pretty: @pretty }
      
    catch ex
      error = "Error: #{ex.message}"
      if ex.type
        error = ex.type + error
      if ex.filename
        error += " in '#{ex.filename}:#{ex.line}:#{ex.column}'"
      
    finally
      callback error, ''
  
  # compile all .siml files and write them to the public folder
  onCompile: (compiled) ->
    
    templates = @getTemplates compiled
    
    write template.path, template.content for template in templates
    
    # delete the junk file
    fs.unlink sysPath.normalize "#{@public}/#{@junkFile}"
  
  # Reads and compiles the SMIL files
  # Returns an array of objects with 'path' and 'result' values
  getTemplates: (compiled) ->
    
    paths = (result.sourceFiles for result in compiled when result.path is sysPath.normalize "#{@public}/#{@junkFile}")[0]
    
    return [] if paths is undefined
    
    paths.map (element, index) =>
      
      path = element.path.replace @rootDir, ''
      
      pathHunks = path.split sysPath.sep
      
      pathHunks.push pathHunks.pop()[...-@extension.length] + 'html'
      pathHunks.splice 0, 1, @public
      
      data = fs.readFileSync element.path, 'utf8'
      content = siml[@generator].parse data, { pretty: @pretty }
      result =
        path: sysPath.join.apply this, pathHunks
        content: content
    