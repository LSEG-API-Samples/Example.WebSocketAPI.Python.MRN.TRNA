# How to get Machine Readable News Analytics via  WebSocket API with Python
- Last update: Dec 2021
- Environment: Windows
- Compiler: Python and Conda distribution
- Prerequisite: Refinitiv Real-Time Distribution System version 3.2.1 and above, or Refinitiv Real-Time -- Optimized credentials, and MRN service

## <a id="overview"></a>Project Overview

This project shows how developers may use the [Websocket API for Pricing Streaming and Real-Time Service](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/refinitiv-websocket-api) aka Websocket API application to consume [Refinitiv News Analytics (TRNA)](https://my.refinitiv.com/content/mytr/en/product/machine-readable-news-analytics.html) data from Refinitiv Real-Time Distribution System (Refinitiv Real-Time Advanced Data Hub and Refinitiv Real-Time Advanced Distribution Server) via Machine Readable News (MRN) domain. The example just connects to Refinitiv Real-Time via a WebSocket connection, then subscribes and shows how to get each TRNA field data in a classic Jupyter Notebook application. The project is implemented with Python language, but the main concept for consuming and assembling MRN and TRNA messages are the same for all technologies. 

You can find the full article regarding this project at [How to get MRN News Analytics Data via WebSocket API](https://developers.refinitiv.com/en/article-catalog/article/how-to-get-mrn-news-analytics-data-via-elektron-websocket-api) page.

This example project supports all Refinitiv Machine Readable News (MRN) data consumption from Refinitiv Real-Time with the WebSocket API. However, the data model description is focusing on the News Analytics (TRNA) data processing only. 

I highly recommend you check the  [WebSocket API Tutorials](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/refinitiv-websocket-api/tutorials) page if you are not familiar with WebSocket API. The Tutorials page provides a step-by-step guide (connect, log in, request data, parse data, etc) for developers who are interested in developing a WebSocket application to consume real-time data from Refinitiv Real-Time. 

If you are focusing on the Real-Time News, please check the following GitHub repositories
- [Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN).
- [Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO)


**Update (As of December 2021)**: The example now supports the Refinitiv Real-Time -- Optimized (RTO - formerly known as ERT in Cloud) connection.
* The RTO examples: 
  - mrn_trna_console_rto.py console application file.
  - Alternatively, please check my colleague's [Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO) GitHub Repository.
  - mrn_trna_notebook_app_rto.ipynb notebook file.
* The deployed Refinitiv Real-Time Distribution System (RTDS) examples are mrn_console_app.py console application and mrn_notebook_app.ipynb notebook files.

## <a id="news_analytics"></a>Refinitiv News Analytics Overview

[Refinitiv News Analytics (TRNA)](https://my.refinitiv.com/content/mytr/en/product/machine-readable-news-analytics.html) provides real-time numerical insight into the events on multiple news sources, in a format that can be directly consumed by algorithmic trading systems. TRNA enables algorithms to exploit the power of news to seize opportunities, capitalize on market inefficiencies, and manage event risk.

TRNA is published via Refinitiv Real-Time as part of Refinitiv Machine Readable News (MRN) data model. MRN is an advanced service for automating the consumption and systematic analysis of news. It delivers deep historical news archives, ultra-low latency structured news, and news analytics directly to your applications. 

### <a id="mrn_data_model"></a>MRN Data Model

MRN is published over Refinitiv Real-Time using an Open Message Model (OMM) envelope in News Text Analytics domain messages. The Real-time News content set is made available over MRN_STORY RIC. The content data is contained in a FRAGMENT field that has been compressed and potentially fragmented across multiple messages, to reduce bandwidth and message size.

A FRAGMENT field has a different data type based on a connection type:
* RSSL connection (RTSDK [C++](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/rt-sdk-cc)/[Java](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/rt-sdk-java)): BUFFER type
* WebSocket connection: Base64 ASCII string

The data goes through the following series of transformations:

1. The core content data is a UTF-8 JSON string
2. This JSON string is compressed using gzip
3. The compressed JSON is split into several fragments (BUFFER or Base64 ASCII string) which each fit into a single update message
4. The data fragments are added to an update message as the FRAGMENT field value in a FieldList envelope

![Figure-1](images/trna_process.png "MRN data compression process") 

Therefore, to parse the core content data, the application will need to reverse this process. The WebSocket application also needs to convert a received Base64 string in a FRAGMENT field to bytes data before further process this field. This application uses Python [base64](https://docs.python.org/3/library/base64.html) and [zlib](https://docs.python.org/3/library/zlib.html) modules to decode Base64 string and decompress JSON string. 

If you are not familiar with MRN concept, please visit the following resources which will give you a full explanation of the MRN data model and implementation logic:
* [Webinar Recording: Introduction to Machine Readable News](https://developers.refinitiv.com/news#news-accordion-nid-12045)
* [Introduction to Machine Readable News (MRN) with Enterprise Message API (EMA)](https://developers.refinitiv.com/en/article-catalog/article/introduction-machine-readable-news-mrn-elektron-message-api-ema).
* [News Analytics Data Models and User Guide section in My Refinitiv's TRNA page](https://my.refinitiv.com/content/mytr/en/product/thomson-reuters-news-analytics.html).
* [MRN Data Models and Refinitiv Real-Time SDK Implementation Guide](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/rt-sdk-java/documentation#mrn-data-models-implementation-guide).
* [Introduction to Machine Readable News with WebSocket API](https://developers.refinitiv.com/en/article-catalog/article/introduction-machine-readable-news-elektron-websocket-api-refinitiv).
* [How to get MRN News Analytics Data via WebSocket API](https://developers.refinitiv.com/en/article-catalog/article/how-to-get-mrn-news-analytics-data-via-elektron-websocket-api).

## <a id="prerequisite"></a>Prerequisite
This example requires the following dependencies software  and libraries.
1. Refinitiv Real-Time Advanced Data Hub and Refinitiv Real-Time Advanced Distribution Server version 3.2.x with WebSocket connection and MRN Service.
2. [Python](https://www.python.org/) interpreter and runtime.
3. Python [Anaconda](https://www.anaconda.com/distribution/) or [MiniConda](https://docs.conda.io/en/latest/miniconda.html) distribution/package manager.
4. [JupyterLab](https://jupyter.org/) web application.
5. RTO Access credentials for the RTO example.
6. Internet connection.
7. [Docker Desktop/Engine](https://docs.docker.com/get-docker/) version 20.10.x and [DockerHub](https://hub.docker.com/) account (free subscription).

*Note:* 
- This Project has been qualified with Python version 3.8 and Conda version 4.10
- If you are not familiar with Jupyter Notebook, the following [tutorial](https://www.datacamp.com/community/tutorials/tutorial-jupyter-notebook) created by DataCamp may help.
- It is not advisable to change the Refinitiv Real-Time Distribution System configuration if you are not familiar with the configuration procedures. Please consult your Market Data administrator for any questions regarding Refinitiv Real-Time Distribution System-MRN service configuration.
- Please contact your Refinitiv's representative to help you to access the RTO account, and services. You can find more detail regarding the RTO access credentials set up from the *Getting Started for Machine ID* section of the [Getting Start with Refinitiv Data Platform article](https://developers.refinitiv.com/en/article-catalog/article/getting-start-with-refinitiv-data-platform) article.
- Please refer to the [pip installation guide page](https://pip.pypa.io/en/stable/installing/) if your environment does not have the [pip tool](https://pypi.org/project/pip/) installed. 


## <a id="project_files"></a>Application Files
This example project contains the following files and folders
1. *notebook_python/mrn_trna_notebook_app.ipynb*: The example Jupyter Notebook application for the deployed RTDS connection file
2. *notebook_python/mrn_trna_notebook_app_rto.ipynb*: The example Jupyter Notebook application for the RTO connection file
3. *notebook_python/.env.example*: The example ```.env``` file for the RTO connection notebook.
4. *console/mrn_trna_console_app.py*: The example console application for the deployed RTDS connection file
5. *console/mrn_trna_console_rto.py*: The example console application  for the RTO connection  file
6. *console/.env.example*: The example ```.env``` file for the RTO connection console application.
7. *requirements.txt*: The basic dependencies configuration file
8. *Dockerfile*: The RTO console application Dockerfile
9. *Dockerfile-notebook*: The RTO notebook application Dockerfile
10. *LICENSE.md*: Project's license file
11. *README.md*: Project's README file
12. .gitignore and .dockerignore: Docker and Git ignore files.

## <a id="how_to_run"></a>How to run this example

The first step is to unzip or download the example project folder into a directory of your choice, then choose how to run the application based on your environment below.

### <a id="how_to_setup"></a>Set Up Environment

It is an advisable to create a dedicate Python environment to run each Python project. You can create a new Conda environment names *MRN_TRNA* with the following steps

1. Open Anaconda Prompt and go to the project's folder
2. Run the following command in an Anaconda Prompt to create a Conda environment named *MRN_TRNA* for the project.
  ```
  (base) $>conda create --name MRN_TRNA python=3.8
  ```
3. Once the environment is created, activate MRN_TRNA environment with this command in Anaconda Prompt
  ```
  (base) $>conda activate MRN_TRNA
  ```
4. Run the following command to install the dependencies in the *MRN_TRNA* environment 
  ```
  (MRN_TRNA) $>pip install -r requirements.txt
  ```

### <a id="rtds_jupyter"></a>RTDS Jupyter Notebook example

Please be informed that your Refinitiv Real-Time Advanced Data Hub and Refinitiv Real-Time Advanced Distribution Server should have a Service that contains MRN data. 

1. Open Anaconda Prompt and go to the project's folder
2. Activate MRN_TRNA environment with this command in Anaconda Prompt
  ```
  (base) $>conda activate MRN_TRNA
  ```
3. Run the following command to install the JupyterLab application in the *MRN_TRNA* environment 
  ```
  (MRN_TRNA) $>conda install -c conda-forge jupyterlab
  ```
4. In the current Anaconda Prompt, go to the project's notebook folder. Run the following command to start the JupyterLab application in the notebook folder.
  ```
  (MRN_TRNA) $>jupyter lab
  ```
5. Open *mrn_trna_notebook_app.ipynb* Notebook document, then follow through each notebook cell.

### <a id="rtds_console"></a>RTDS Console example

Please be informed that your Refinitiv Real-Time Advanced Data Hub and Refinitiv Real-Time Advanced Distribution Server should have a Service that contains MRN data. 

1. Open Anaconda Prompt and go to the project's folder
2. Activate MRN_TRNA environment with this command in Anaconda Prompt
  ```
  (base) $>conda activate MRN_TRNA
  ```
3. Then you can run mrn_trna_console_app.py application with the following command
  ```
  (MRN_TRNA) $> python console/mrn_trna_console_app.py --hostname <Real-Time Advanced Distribution Server IP Address/Hostname> --port <WebSocket Port> 
  ```
4. The application subscribes ```MRN_TRNA``` RIC code from Real-Time Advanced Distribution Server by default. 

### <a id="rto_jupyter"></a>RTO Jupyter Notebook example

Please be informed that your RTO access credentials should have a permission to request MRN data. 

1. Open Anaconda Prompt and go to the project's folder
2. Activate MRN_TRNA environment with this command in Anaconda Prompt
  ```
  (base) $>conda activate MRN_TRNA
  ```
3. Run the following command to install the JupyterLab application in the *MRN_TRNA* environment 
  ```
  (MRN_TRNA) $>conda install -c conda-forge jupyterlab
  ```
4. Go to the project's notebook folder. and create a file name ```.env``` with the following content.
  ```
  # RTO Credentials
  RTO_USERNAME=<Your RTO Machine-ID>
  RTO_PASSWORD=<Your RTO Password>
  RTO_CLIENTID=<Your RTO App Key>

  # RDP-RTO Core Configurations
  RDP_BASE_URL=https://api.refinitiv.com
  RDP_AUTH_URL=/auth/oauth2/v1/token
  RDP_DISCOVERY_URL=/streaming/pricing/v1/
  ```
5. In the current Anaconda Prompt notebook folder. Run the following command to start the JupyterLab application in the notebook folder.
  ```
  (MRN_TRNA) $>jupyter lab
  ```
6. Open *mrn_trna_notebook_app_rto.ipynb* Notebook document, then follow through each notebook cell.

### <a id="rto_console"></a>RTO console example

Please be informed that your RTO access credentials should have a permission to request MRN data. 

1. Open Anaconda Prompt and go to the project's folder
2. Activate MRN_TRNA environment with this command in Anaconda Prompt
  ```
  (base) $>conda activate MRN_TRNA
  ```
3. Go to the project's console folder. and create a file name ```.env``` with the following content.
  ```
  # RTO Credentials
  RTO_USERNAME=<Your RTO Machine-ID>
  RTO_PASSWORD=<Your RTO Password>
  RTO_CLIENTID=<Your RTO App Key>

  # RDP-RTO Core Configurations
  RDP_BASE_URL=https://api.refinitiv.com
  RDP_AUTH_URL=/auth/oauth2/v1/token
  RDP_DISCOVERY_URL=/streaming/pricing/v1/
  ```
4. Then you can run mrn_trna_console_rto.py application with the following command
  ```
  (MRN_TRNA) $>python console/mrn_trna_console_rto.py --ric <MRN_TRNA RIC code by default> 
  ```

Alternatively, please check my colleague's [Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO) GitHub Repository.

### <a id="rto_console_docker"></a>Bonus: RTO console Docker example

Please be informed that your RTO access credentials should have a permission to request MRN data. 

1. Go to the project folder in a console and create a file name ```.env``` in a ```console``` folder with the following content.
  ```
  # RTO Credentials
  RTO_USERNAME=<Your RTO Machine-ID>
  RTO_PASSWORD=<Your RTO Password>
  RTO_CLIENTID=<Your RTO App Key>

  # RDP-RTO Core Configurations
  RDP_BASE_URL=https://api.refinitiv.com
  RDP_AUTH_URL=/auth/oauth2/v1/token
  RDP_DISCOVERY_URL=/streaming/pricing/v1/
  ```
2. Run ```$> docker build -t <project tag name> .``` command in a console to build an image from a Dockerfile.
  ```
  $> docker build -t rto_ws_mrn_python .
  ```
3. Once the build is a success, you can create and run the container with the following command
  ```
  $> docker run --name mrn_console -it --env-file ./console/.env rto_ws_mrn_python --ric <MRN_TRNA RIC code by default> 
  ```
4. Press Ctrl+C buttons to stop the application

### <a id="rto_jupyter_docker"></a>Bonus: RTO Jupyter Docker example

Please be informed that your RTO access credentials should have a permission to request MRN data. 

1. Go to the project folder in a console and create a file name ```.env``` in a ```notebook``` folder with the following content.
  ```
  # RTO Credentials
  RTO_USERNAME=<Your RTO Machine-ID>
  RTO_PASSWORD=<Your RTO Password>
  RTO_CLIENTID=<Your RTO App Key>

  # RDP-RTO Core Configurations
  RDP_BASE_URL=https://api.refinitiv.com
  RDP_AUTH_URL=/auth/oauth2/v1/token
  RDP_DISCOVERY_URL=/streaming/pricing/v1/
  ```
2. Run ```$> docker build -f Dockerfile-notebook -t <project tag name> .``` command in a console to build an image from a Dockerfile-notebook.
  ```
  $> docker build -f Dockerfile-notebook -t mrn_notebook .
  ```
3. Once the build is a success, you can create and run the container with the following command
  ```
  $> docker run -p 8888:8888 --name notebook -v <project /notebook/ directory>:/home/jovyan/work --env-file ./notebook/.env -it mrn_notebook
  ```
4. The mrn_notebook container will run the Jupyter server and print the server URL in a console. 
5. Open the notebook server URL in your browser, the web browser will start the JupyterLab application.
6. Press Ctrl+C buttons to stop the application

For more detail regarding how to use Docker with Jupyter, please check this [Article.RDP.RDPLibrary.Python.R.JupyterDocker](https://github.com/Refinitiv-API-Samples/Article.RDP.RDPLibrary.Python.R.JupyterDocker) project.

## Example Results
### Send MRN_STORY request to Real-Time Advanced Distribution Server
```
SENT:
{
  "Domain":"NewsTextAnalytics",
  "ID":2,
  "Key":{
    "Name":"MRN_TRNA"
  }
}
RECEIVED: 
[
  {
    "Domain":"NewsTextAnalytics",
    "Fields":{
      "ACTIV_DATE":"1970-01-01",
      "CONTEXT_ID":3929,
      "DDS_DSO_ID":12424,
      "FRAGMENT":null,
      "FRAG_NUM":0,
      "GUID":null,
      "MRN_SRC":"4.1.3_na_ent0-c383quja1adtc",
      "MRN_TYPE":null,
      "MRN_V_MAJ":null,
      "MRN_V_MIN":null,
      "PROD_PERM":10002,
      "RDN_EXCHD2":"MRN",
      "RECORDTYPE":30,
      "SPS_SP_RIC":".[SPSMANL1",
      "TIMACT_MS":0,
      "TOT_SIZE":0
    },
    "ID":2,
    "Key":{
      "Name":"MRN_TRNA",
      "Service":"API_RDF"
    },
    "PermData":"Ax+yEAAs",
    "Qos":{
      "Rate":"TickByTick",
      "Timeliness":"Realtime"
    },
    "SeqNumber":35024,
    "State":{
      "Data":"Ok",
      "Stream":"Open",
      "Text":"All is well"
    },
    "Type":"Refresh"
  }
]
```

### Receive Update message and assemble News 
```
RECEIVED: 
[
  {
    "DoNotCache":true,
    "DoNotConflate":true,
    "Domain":"NewsTextAnalytics",
    "Fields":{
      "ACTIV_DATE":"2020-02-12",
      "FRAGMENT":"H4sIAAAAAAAA/81V3XPaOBD/Vxi/lmRkAYX4zV9QUmwc2w3p3dx0hK0QBduisoHSDv97V5IppJPmZu7p/LD6eb+kXe2ufhikIsWhYVltWD/OP0nGBQXW38Cra9q4BSyGZbhBFH42ui2T50rHiKw+vhkhNBxiBMLYms+D5HoeGP+0mtMcbF/oKHZISgqCeUmqzpwVnYCINW1Yteq4vJPY8wkoLgVfU2FnDeMV6H4KPX88DX0PRI9M1E1AKylKYKFVBu7MrlGwak3zaa4DYHnEa6bt0VkIzhphjRchtl00mH3BCGETm2VV7T1W3zvpfhIHvuMt5jh+ekia5cNyVHs9hm6f18YRIqv4jhbNweXbqml3amipftUp9qzK+R62MfEH49j9oxj33xT3vLekgzelQ0+ddCNYRlMiVnATVc4y0nDxWy4FLeiO6AReI/l1jVqmtgTS3r55wQrpijRsB+roGvUxHmL8QrptBCmk0MSj/qB3IdOXoS1H+AYPBxfCBRd5G0e/3zV2vNiW9H+fYVUNdF9PQUe20ZLnh4R9hxAxhtAzXm5IdThb02/ZE6lW9NWqfqIkhxqF+1qBxImn/hi4pWoNl5cyS0QcDOuRFDXVqZOF33qHZO7PORzgI2gcajjXPRW13ixNrD5C75FpYogM2uP1TsDO8p0z4ruHcvjcG9ki9t6/C2+/Reh2PD087u8+fjezxY3xMvKcNCQ9bGRXh8CWTUppPiYlKw5yXKitLoI8RXj1ygxwOBF5JxJ8w2tad8afOx7bsZxWeQc8FJDALVlJD7SSCaINkburMVboiVP9iklOnG3OZKLUxAojywceLJNxqEGUuBrEYaSBdwKRO5ejTIaSQpnWDSk3sqwQRlcIX5k4RX1rgKweuh4i9NdpNLmCkobmf9BEWpPVtsieVD+0N9qQNU3o1207zo6yf7kMXPZsmFhxGidgWPOtyKiK8z9fnfbxbzG1J623y2eaqUY0Aks9A4ElBb4lK3RimYreKTp0YHGskaImMpECWFPzRq0DZWsqOlFW2s8HRT8qmrx4T7q/PzWBZd7Jpgmx5cxiDU5vFEBveq+BH8QTjQLfTlINlUNYY+i9MzJbi3A8PiG/9Tyfzlovju2mJ5NEg3Qyaw2ShZ1MbY0v0UNkuxrP/FAW1BYmcpVBL/eOx5+IdgrvigcAAA==",
      "FRAG_NUM":1,
      "GUID":"tr:FWN2AC05L_2002122Bb+B8ovXm7j38ArRD6+NJxP0JFIyfwQKz1cW9",
      "MRN_SRC":"C383QUJA1ADTC-4.0.6_TRNA-C383QUJA1ADTC",
      "MRN_TYPE":"TRNA",
      "MRN_V_MAJ":"2",
      "MRN_V_MIN":"10",
      "TIMACT_MS":17430856,
      "TOT_SIZE":886
    },
    "ID":2,
    "Key":{
      "Name":"MRN_TRNA",
      "Service":"API_RDF"
    },
    "PermData":"Ax+yEAAqEAEKEAILEAIqEAQLEAQrEARbEAZKEBAaEBGbEBIaECMLECYrECY7ECiLEDEM",
    "SeqNumber":35056,
    "Type":"Update",
    "UpdateType":"Unspecified"
  }
]
FRAGMENT length = 886
decompress News FRAGMENT(s) for GUID  tr:FWN2AC05L_2002122Bb+B8ovXm7j38ArRD6+NJxP0JFIyfwQKz1cW9
News = {'analytics': {'analyticsScores': [{'assetClass': 'CMPNY', 'assetCodes': ['P:4298007720', 'R:OOMS.OM'], 'assetId': '4298007720', 'assetName': 'Oman Oil Marketing Co SAOG', 'brokerAction': 'UNDEFINED', 'firstMentionSentence': 1, 'linkedIds': [{'idPosition': 0, 'linkedId': 'tr:FWN2AC05L_2002121mnnwDisVBTwGRMEBDWO2RhXStbXb8sD3i0Jjk'}], 
'noveltyCounts': [{'itemCount': 1, 'window': '12H'}, {'itemCount': 1, 'window': '24H'}, {'itemCount': 1, 'window': '3D'}, {'itemCount': 1, 'window': '5D'}, {'itemCount': 1, 'window': '7D'}], 'priceTargetIndicator': 'UNDEFINED', 'relevance': 1.0, 'sentimentClass': 1, 'sentimentNegative': 0.0422722, 'sentimentNeutral': 0.128453, 'sentimentPositive': 0.829275, 'sentimentWordCount': 44, 
'volumeCounts': [{'itemCount': 1, 'window': '12H'}, {'itemCount': 1, 'window': '24H'}, {'itemCount': 1, 'window': '3D'}, 
{'itemCount': 1, 'window': '5D'}, {'itemCount': 1, 'window': '7D'}]}], 'newsItem': {'bodySize': 223, 'companyCount': 1, 'exchangeAction': 'UNDEFINED', 'headlineTag': 'BRIEF', 'marketCommentary': False, 'sentenceCount': 5, 'wordCount': 52}, 
'systemVersion': 'TS:40060112'}, 'id': 'tr:FWN2AC05L_2002122Bb+B8ovXm7j38ArRD6+NJxP0JFIyfwQKz1cW9', 'newsItem': 
{'dataType': 'News', 'feedFamilyCode': 'tr', 'headline': 'BRIEF-Oman Oil Marketing Board Proposes FY Dividend ', 'language': 'en', 'metadata': {'altId': 'nFWN2AC05L', 'audiences': ['NP:E', 'NP:GFN', 'NP:PSC', 'NP:RNP', 'NP:DNP', 'NP:PCO'], 
'feedTimestamp': '2020-02-12T04:50:30.700Z', 'firstCreated': '2020-02-12T04:50:30.000Z', 'isArchive': False, 'takeSequence': 1}, 'provider': 'NS:RTRS', 'sourceId': 'FWN2AC05L_2002122Bb+B8ovXm7j38ArRD6+NJxP0JFIyfwQKz1cW9', 
'sourceTimestamp': '2020-02-12T04:50:30.000Z', 'subjects': ['M:NY', 'M:Z', 'E:F', 'G:1', 'G:Q',
 'G:7B', 'B:8', 'B:1010', 'B:2', 'B:219', 'B:5', 'E:1', 'E:G', 'G:F', 'G:H', 'G:K', 'G:S', 
 'R:OOMS.OM', 'P:4298007720', 'M:1QD', 'N2:BLR', 'N2:CMPNY', 'N2:DIV', 'N2:EMRG', 'N2:MEAST', 
 'N2:OM', 'N2:REFI', 'N2:REFI1', 'N2:ENFF', 'N2:ENER', 'N2:OILG', 'N2:BACT', 'N2:RES', 'N2:TGLF', 
 'N2:SWASIA', 'N2:ASIA', 'N2:ASXPAC', 'N2:LEN'], 'urgency': 3}}
```

## <a id="references"></a>References
For further details, please check out the following resources:

* [Refinitiv Real-Time & Distribution Family page](https://developers.refinitiv.com/en/use-cases-catalog/refinitiv-real-time) on the [Refinitiv Developer Community](https://developers.refinitiv.com/) website.
* [WebSocket API page](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/refinitiv-websocket-api).
* [Developer Webinar Recording: Introduction to WebSocket API](https://www.youtube.com/watch?v=CDKWMsIQfaw).
* [Refinitiv News Analytics Product page](https://my.refinitiv.com/content/mytr/en/product/machine-readable-news-analytics.html).
* [Introduction to Machine Readable News with WebSocket API](https://developers.refinitiv.com/en/article-catalog/article/introduction-machine-readable-news-elektron-websocket-api-refinitiv).
* [How to get MRN News Analytics Data via WebSocket API](https://developers.refinitiv.com/en/article-catalog/article/how-to-get-mrn-news-analytics-data-via-elektron-websocket-api).
* [Introduction to Machine Readable News (MRN) with Enterprise Message API (EMA)](https://developers.refinitiv.com/en/article-catalog/article/introduction-machine-readable-news-mrn-elektron-message-api-ema).
* [MRN Data Models and Real-Time SDK Implementation Guide](https://developers.refinitiv.com/en/api-catalog/refinitiv-real-time-opnsrc/rt-sdk-java/documentation#mrn-data-models-implementation-guide).
* [MRN (Real-Time News) WebSocket Python example on GitHub](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN).
* [MRN (Real-Time News) WebSocket Python Console example on GitHub](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Python.MRN.RTO)
* [MRN WebSocket JavaScript example on GitHub](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.Javascript.NewsMonitor).
* [MRN WebSocket C# NewsViewer example on GitHub](https://github.com/Refinitiv-API-Samples/Example.WebSocketAPI.CSharp.MRNWebSocketViewer).

For any question related to this example or WebSocket API, please use the Developer Community [Q&A Forum](https://community.developers.refinitiv.com/spaces/152/websocket-api.html).