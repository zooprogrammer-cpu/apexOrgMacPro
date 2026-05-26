<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Account Opportunities Export</label>
    <protected>false</protected>
    <values>
        <field>Config_Key__c</field>
        <value xsi:type="xsd:string">ACC_OPPTY_EXPORT</value>
    </values>
    <values>
        <field>Root_Object_API_Name__c</field>
        <value xsi:type="xsd:string">Account</value>
    </values>
    <values>
        <field>Child_Object_API_Name__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
    <values>
        <field>Object_API_Name__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
    <values>
        <field>Child_Relationship_Field_API_Name__c</field>
        <value xsi:type="xsd:string">AccountId</value>
    </values>
    <values>
        <field>File_Name_Template__c</field>
        <value xsi:type="xsd:string">Export_{ObjectApiName}_{DateTime}</value>
    </values>
    <values>
        <field>Max_Record_Count__c</field>
        <value xsi:type="xsd:double">5000</value>
    </values>
    <values>
        <field>Is_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
</CustomMetadata>
