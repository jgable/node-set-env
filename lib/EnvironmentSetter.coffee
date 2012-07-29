exec = (require "child_process").exec

class EnvironmentSetter
    setVariables: (configData) ->
        
        for own key, val of configData
            exportVals = "#{key}=\"#{val}\""

            # Using do to force a closure in our for loop.            
            do (exportVals) ->
                # May need to switch from exec here, haven't tested.
                exec "export", [exportVals], (err, stdout, stderr) ->
                    throw err if err
                    console.log "Exported: #{exportVals}"

module.exports = EnvironmentSetter