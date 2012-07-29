exec = (require "child_process").exec

class EnvironmentSetter
    setVariables: (configData = {}) ->
        for own key, val in configData
            # May need to switch from exec here, haven't tested.
            exec "export", ["#{key}=\"#{val}\""]

module.exports = EnvironmentSetter