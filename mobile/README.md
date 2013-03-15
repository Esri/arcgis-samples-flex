This folder contains the mobile samples for the ArcGIS API for Flex.

## Getting Started

**Note:**  *These steps apply to the BasicMap sample, but are also applicable to the WebMap sample.*

1. Open Adobe Flash Builder, choose File -> Import Flash Builder Project.
2. Select Project folder, click Browse, and navigate to the downloaded "mobile/BasicMap" folder. 
3. Add the API Library to the project through Project.
    * Go to Project -> Properties -> Flex Build Path -> Library Path -> Add SWC (and locate the "agslib-#.#-YYYY-MM-DD.swc").
    * Alternatively, copy the swc library to the libs folder under the "BasicMap" project.
4. Run the application using a simulator or on a physical device. Using the Run Configurations (Run > Run Configuration) you can add a Mobile application and define the Launch method as appropriate.

**Notes about the "BasicMap" Run Configuration:**
    
* Name: BasicMap
    * Project: BasicMap
    * Application file: src/BasicMap.mxml
    * Target platform: Apple iOS or Google Android 
    * Launch method: 
        * On AIR Simulator
        * On device
        
*Target platform Apple iOS requires a Certificate and Provisioning file*, [Learn more about Apple iOS deployment][1].

For more information see the [Mobile applications with Flex][2] topic in the [API Concepts][3].

[1]: http://www.adobe.com/go/fb47_ios
[2]: http://resources.arcgis.com/en/help/flex-api/concepts/#/Mobile_applications_with_Flex/017p00000025000000/
[3]: http://resources.arcgis.com/en/help/flex-api/concepts/index.html
