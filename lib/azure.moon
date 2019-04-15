-- azure.moon

-- AzurePostgreSQLDatabase is a class for working with Azure PostgreSQL DB that plugs into with the Azure mixin
class AzurePostgreSQLDatabase
    _format: (o) => {azure: o}

    new: (@name, @location, @database, @username, @password) =>

    get_host: =>
        @name..".postgres.database.azure.com"

    install: =>
        @_format({
            description:   "Install azure postgres db \""..@name.."\" (in "..@location..")"
            type:          "postgres"
            name:          @name
            resourceGroup: @name
            parameters: {
                serverName:                 @name
                location:                   @location
                databaseName:               @database
                administratorLogin:         @username
                administratorLoginPassword: @password
            }
            outputs: {
                {
                    name: "POSTGRESQL_HOST"
                    key:  "POSTGRESQL_HOST"
                }
            }
        })

    upgrade: =>
        @_format({
            description:   "Upgrade azure postgres db \""..@name.."\" (in "..@location..")"
            type:          "postgres"
            name:          @name
            resourceGroup: @name
            parameters: {
                serverName:                 @name
                location:                   @location
                databaseName:               @database
                administratorLogin:         @username
                administratorLoginPassword: @password
            }
            outputs: {
                {
                    name: "POSTGRESQL_HOST"
                    key:  "POSTGRESQL_HOST"
                }
            }
        })

    uninstall: =>
        @_format({
            description:   "Uninstall azure postgres db \""..@name.."\" (in "..@location..")"
            type:          "postgres"
            name:          @name
            resourceGroup: @name
            parameters: {
                serverName:                 @name
                location:                   @location
                databaseName:               @database
                administratorLogin:         @username
                administratorLoginPassword: @password
            }
            outputs: {
                {
                    name: "POSTGRESQL_HOST"
                    key:  "POSTGRESQL_HOST"
                }
            }
        })
return {
    AzurePostgreSQLDatabase: AzurePostgreSQLDatabase
}
