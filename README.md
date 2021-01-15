# helloeternity
An application for fetching Astronomy Picture Of the Day (APOD) with corresponding information from NASA API. 

Implemented features: 
- Networking;
- Persistence (Core Data);
- APOD search by date. 

TODO: 
- Processing received videos and corresponding UI changes for this case (sometimes API sends video links instead of images);
- Ability to save HD images to Photos. 

Known issues: 
- Double-saving of APOD in some cases.

Notes: 
- You may generate your personal key instead of the demo one. 
- There is a limit to the number of requests sent in one period of time, that's why you may face infinite loading of APOD and need to wait until the API allows sending the requests again.
