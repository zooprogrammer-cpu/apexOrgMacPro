public class FileUploadController {
    public Blob fileBody { get; set; }
    public String fileName { get; set; }
    public String contentType { get; set; }

    public PageReference uploadFile() {
        Map<String, String> metadataMap = new Map<String, String>{'ExampleKey' => 'ExampleValue'};
        Blob fileContent = fileBody;
        HttpResponse response = UploadAudio.sendMultiPartForm(fileContent, contentType, fileName, metadataMap);
        // Handle the response as needed
        System.debug('response:' + response);
        return null;
    }
}