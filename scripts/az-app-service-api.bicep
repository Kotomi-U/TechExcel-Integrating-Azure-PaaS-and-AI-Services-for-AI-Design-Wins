@description('Location of the resources')
param location string = resourceGroup().location

var appServicePlanName = '${uniqueString(resourceGroup().id)}-cosu-win-asp'
var appServiceApiName = '${uniqueString(resourceGroup().id)}-api'
var appServiceSku = 'B1'

// Create App Service Plan with Publishing model = code and runtime stack = .NET Core 8.0 on Windows
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServiceSku
  }
  kind: 'app'
  properties: {
    reserved: false
  }
}

resource appServiceApi 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceApiName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'AzureOpenAI__DeploymentName'
          value: 'gpt-4o'
        }
        {
          name: 'AzureOpenAI__Endpoint'
          value: 'https://gfj3ngyufhlxc-openai.openai.azure.com/'
        }
        {
          name: 'AzureOpenAI__ApiKey'
          value: 'adcb8982f7284757b5e7f6338c89e8e5'
        }
        {
          name: 'ConnectionStrings:ContosoSuites'
          value: 'Server=tcp:gfj3ngyufhlxc-sqlserver.database.windows.net,1433;Initial Catalog=ContosoSuitesBookings;Persist Security Info=False;User ID=contosoadmin;Password=@dm1np@ssw0rd;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;'
        }
      ]
    }
  }
}

output appServiceApiName string = appServiceApi.name

