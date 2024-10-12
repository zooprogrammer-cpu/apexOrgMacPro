/**
 * 
 */

public with sharing class UploadAudio {

    // form boundary must be a string that will very likely never appear again in the form
    public static final String BOUNDARY = '----FormBoundary4Amf13kZd';
    public static final String EXTRABOUNDARY = '--' + BOUNDARY;

    /**
     *
     *
     * @param file The file that will be uploaded.
     * @param contentType The content-type of the file.  Will default to application/octet-stream.
     * @param filename Name to give the file.
     * @param formDataMap Any extra metadata that you want to send.
     *
     * @return Blob of the complete multipart form.
     */
    public static Blob multiPartFormDataBody(Blob file, String contentType, String filename, Map<String, String> metadataMap) {
        contentType = contentType == '' ? 'application/octet-stream' : contentType;
        String bodyStartHex = EncodingUtil.convertToHex(Blob.valueOf(EXTRABOUNDARY + '\r\nContent-Disposition: form-data; name=\"file\"; filename="' + filename + '"\r\nContent-Type: ' + contentType + '\r\n\r\n'));
        String bodyEndHex = EncodingUtil.convertToHex(Blob.valueOf(EXTRABOUNDARY + '--\r\n'));

        bodyStartHex += EncodingUtil.convertToHex(file);
        if (metadataMap != null && metadataMap.size() != 0) {
            String formElements = '\r\n';
            for (String key : metadataMap.keySet()) {
                formElements += EXTRABOUNDARY + '\r\nContent-Disposition: form-data; name=\"' + key + '\"\r\n\r\n' + metadataMap.get(key) + '\r\n';
            }
            bodyStartHex += EncodingUtil.convertToHex(Blob.valueOf(formElements));
        } else {
            // the extra '--' at the end is crucial
            bodyEndHex = EncodingUtil.convertToHex(Blob.valueOf('\r\n' + EXTRABOUNDARY + '--'));
        }
        return EncodingUtil.convertFromHex(bodyStartHex + bodyEndHex);
    }

    public static HttpResponse sendMultiPartForm(Blob file, String contentType, String filename, Map<String, String> metadataMap) {
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint('https://httpbin.org/post');
        request.setMethod('POST');
        // Boundary must be set to exactly what was set before
        request.setHeader('Content-Type', 'multipart/form-data; boundary=' + BOUNDARY);
        request.setBodyAsBlob(multiPartFormDataBody(file, contentType, filename, metadataMap));
        request.setHeader('Content-Length', String.valueOf(request.getBodyAsBlob().size()));
        return http.send(request);
    }

}