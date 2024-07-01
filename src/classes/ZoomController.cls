@RestResource(UrlMapping='/voicecalls')
global with sharing class ZoomController {
    public String body {get; set;}
    public String searchQuery {get;set;}

    @HttpPost
    global static VoiceCall doPost() {
        RestRequest req = RestContext.request;
        String s = req.requestBody.toString();
        System.debug('doPost s' + s);
        // Deserialize it into the VoiceCall class
        VoiceCall v = (VoiceCall) JSON.deserialize(s, VoiceCall.class);
        insert v;
        return v;
    }

    public void getMeetingDetails() {
        String sanitizedQuery = searchQuery.replaceAll(' ', '+' );

//        String meetingId = '81941079427';


        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Get_Meetings' + '/v2/meetings/' + sanitizedQuery);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        body = response.getBody();

        System.debug('body 🚀: ' + body);

        // Deserialize -
        fromJSON deserialized = (fromJSON) JSON.deserialize(body, fromJSON.class);
        System.debug(deserialized.start_time);
        System.debug(deserialized.topic);

        insertCallDetails(deserialized);


    }

    public static void insertCallDetails(fromJSON deserialized) {

        Account acc = new Account();
        acc.Name = deserialized.topic;
        insert acc;
    }

    //


    public class fromJSON{
        public String uuid;	//NsMHOqtoSYOl3YSAsYYPdA==
        public String id;	//81941079427
        public String host_id;	//efwkRksaRwqHPku2r66GeA
        public String host_email;	//ashbasn@outlook.com
        public String assistant_id;	//
        public String topic;	//Ash Basnyat's First Zoom Meeting
        public Integer type;	//2
        public String status;	//waiting
        public String start_time;	//2024-06-21T18:00:00Z
        public Integer duration;	//30
        public String timezone;	//America/Chicago
        public String agenda;	//
        public String created_at;	//2024-06-21T17:51:59Z
        public String start_url;	//https://us05web.zoom.us/s/81941079427?zak=eyJ0eXAiOiJKV1QiLCJzdiI6IjAwMDAwMSIsInptX3NrbSI6InptX28ybSIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJ3ZWIiLCJjbHQiOjAsIm1udW0iOiI4MTk0MTA3OTQyNyIsImF1ZCI6ImNsaWVudHNtIiwidWlkIjoiZWZ3a1Jrc2FSd3FIUGt1MnI2NkdlQSIsInppZCI6ImFjNjBkZjllZDBkMTRjNDg4NTBlZjIzZTJiMGExNWRlIiwic2siOiIwIiwic3R5IjoxMDAsIndjZCI6InVzMDUiLCJleHAiOjE3MTk3MDA1OTksImlhdCI6MTcxOTY5MzM5OSwiYWlkIjoiYm5nSnBEYV9RbHFkZnp6NVBIamItdyIsImNpZCI6IiJ9.GljwS223DR3eX3KPkbVZ9pdISwahzDZQXBKr_By1bkc
        public String join_url;	//https://us05web.zoom.us/j/81941079427?pwd=rZUzNhEJBzcm9fd72nmve8s97kQvlZ.1
        public String password;	//7fEmpq
        public String h323_password;	//853106
        public String pstn_password;	//853106
        public String encrypted_password;	//rZUzNhEJBzcm9fd72nmve8s97kQvlZ.1
//        public cls_settings settings;
        public boolean pre_schedule;

    }

    class cls_settings {
        public boolean host_video;
        public boolean participant_video;
        public boolean cn_meeting;
        public boolean in_meeting;
        public boolean join_before_host;
        public Integer jbh_time;	//0
        public boolean mute_upon_entry;
        public boolean watermark;
        public boolean use_pmi;
        public Integer approval_type;	//2
        public String audio;	//voip
        public String auto_recording;	//none
        public boolean enforce_login;
        public String enforce_login_domains;	//
        public String alternative_hosts;	//
        public boolean alternative_host_update_polls;
        public boolean close_registration;
        public boolean show_share_button;
        public boolean allow_multiple_devices;
        public boolean registrants_confirmation_email;
        public boolean waiting_room;
        public boolean request_permission_to_unmute_participants;
        public boolean registrants_email_notification;
        public boolean meeting_authentication;
        public String encryption_type;	//enhanced_encryption
        public cls_approved_or_denied_countries_or_regions approved_or_denied_countries_or_regions;
        public cls_breakout_room breakout_room;
        public boolean internal_meeting;
        public cls_continuous_meeting_chat continuous_meeting_chat;
        public boolean participant_focused_meeting;
        public boolean push_change_to_calendar;
        public cls_resources[] resources;
        public boolean auto_start_meeting_summary;
        public boolean alternative_hosts_email_notification;
        public boolean show_join_info;
        public boolean device_testing;
        public boolean focus_mode;
        public cls_meeting_invitees[] meeting_invitees;
        public boolean enable_dedicated_group_chat;
        public boolean private_meeting;
        public boolean email_notification;
        public boolean host_save_video_order;
        public cls_sign_language_interpretation sign_language_interpretation;
        public boolean email_in_attendee_report;
    }
    class cls_approved_or_denied_countries_or_regions {
        public boolean enable;
    }
    class cls_breakout_room {
        public boolean enable;
    }
    class cls_continuous_meeting_chat {
        public boolean enable;
        public boolean auto_add_invited_external_users;
        public String channel_id;	//web_sch_aeeb15e56e05402b91579a16d9ea7397
    }
    class cls_resources {
    }
    class cls_meeting_invitees {
    }
    class cls_sign_language_interpretation {
        public boolean enable;
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }


}