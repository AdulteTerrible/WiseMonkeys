//
//  TGAppConfiguration.h
//  Telegraph
//
//  Created by Sébastien on 21-3-15.
//
//

#ifndef Telegraph_TGAppConfiguration_h
#define Telegraph_TGAppConfiguration_h

#define API_ID                      12239
#define API_ID_STR                  @"12239"                            // should be the same as API_ID
#define API_HASH                    @"00837edd818e40e4857cdd6ce096a1f4" // you can create new app on my.telegram.org

#define API_PUBLIC_KEY              @"-----BEGIN RSA PUBLIC KEY-----\nMIIBCgKCAQEAxq7aeLAqJR20tkQQMfRn+ocfrtMlJsQ2Uksfs7Xcoo77jAid0bRt\nksiVmT2HEIJUlRxfABoPBV8wY9zRTUMaMA654pUX41mhyVN+XoerGxFvrs9dF1Ru\nvCHbI02dM2ppPvyytvvMoefRoL5BTcpAihFgm5xCaakgsJ/tH5oVl74CdhQw8J5L\nxI/K++KJBUyZ26Uba1632cOiq05JBUW0Z2vWIOk4BLysk7+U9z+SxynKiZR3/xdi\nXvFKk01R3BHV+GUKM2RYazpS/P8v7eyKhAbKxOdRcFpHLlVwfjyM1VlDQrEZxsMp\nNTLYXb6Sce1Uov0YtNx5wEowlREH1WOTlwIDAQAB\n-----END RSA PUBLIC KEY-----"
#define API_PK_FINGERPRINT          0x9a996a1db11c729b

#define API_DATASERVER_IP_RELEASE   @"149.154.167.50"
#define API_DATASERVER_IP_DEBUG     @"149.154.167.40"
#define API_DATASERVER_PORT         443

#ifdef RELEASE
#define API_DATASERVER_IP           API_DATASERVER_IP_RELEASE
#else
#define API_DATASERVER_IP           API_DATASERVER_IP_DEBUG
#endif

#endif
