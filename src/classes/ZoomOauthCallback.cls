public without sharing class ZoomOauthCallback {
    public void handleCallback() {
        String zoomClientId = 'CYLDj1LSZmdOeV3vfMMpA'; // Replace with your Zoom Client ID
        String zoomClientSecret = 'Lr6IfMXTGAp1jHWtHAneqyppqUBJx6h1'; // Replace with your Zoom Client Secret
        String zoomRedirectUri = 'https://ashlearncode2-dev-ed.lightning.force.com/apex/ZoomOAuthCallback'; // Replace with your Salesforce instance URL

        String code = ApexPages.currentPage().getParameters().get('code');
        String tokenUrl = 'https://zoom.us/oauth/token?grant_type=authorization_code&code=' + code + '&redirect_uri=' + EncodingUtil.urlEncode(zoomRedirectUri, 'UTF-8');

        String scheduledUserName = 'Test User';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenUrl);
        req.setMethod('POST');
        String authHeader = EncodingUtil.base64Encode(Blob.valueOf(zoomClientId + ':' + zoomClientSecret));
        req.setHeader('Authorization', 'Basic ' + authHeader);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            // Parse the access token from the response
            Map<String, Object> tokenData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) tokenData.get('access_token');

            // Use the access token to create a Zoom meeting and obtain the meeting URL
            String zoomMeetingUrl = 'https://api.zoom.us/v2/users/me/meetings';
            String requestBody = '{ "topic": "Appointment with ' + scheduledUserName + '", "type": 2, "start_time": "2023-12-31T23:59:59Z", "timezone": "America/New_York" }';

            HttpRequest meetingReq = new HttpRequest();
            meetingReq.setEndpoint(zoomMeetingUrl);
            meetingReq.setMethod('POST');
            meetingReq.setHeader('Content-Type', 'application/json');
            meetingReq.setHeader('Authorization', 'Bearer ' + accessToken);
            meetingReq.setBody(requestBody);

            HttpResponse meetingRes = http.send(meetingReq);
            if (meetingRes.getStatusCode() == 201) {
                // Meeting created successfully, parse the meeting URL from the response
                Map<String, Object> meetingData = (Map<String, Object>) JSON.deserializeUntyped(meetingRes.getBody());
                String zoomUrl = (String) meetingData.get('join_url');
                //return zoomUrl;
            } else {
                // Error creating the meeting
                //return null;
            }
        }

        else {
            // Error obtaining the access token
            //return null;
        }
    }
}