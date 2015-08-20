require 'zoho_crm/version'
require 'httparty'

module ZohoCrm
  class Client

    AUTH_URL = "https://accounts.zoho.com/apiauthtoken/nb/create?SCOPE=ZohoCRM/crmapi&"
    GET_LEADS = "https://crm.zoho.com/crm/private/json/Leads/getRecords?"
    GET_CONTACTS = "https://crm.zoho.com/crm/private/json/Contacts/getRecords?"
    NEW_LEAD = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"
    NEW_CONTACT = "https://crm.zoho.com/crm/private/xml/Contacts/insertRecords?"
    UPDATE_LEAD = "http://crm.zoho.com/crm/private/xml/Leads/updateRecords?"
    UPDATE_CONTACT = "http://crm.zoho.com/crm/private/xml/Contacts/updateRecords?"
    DELETE_LEAD = "http://crm.zoho.com/crm/private/xml/Leads/deleteRecords?"
    DELETE_CONTACT = "http://crm.zoho.com/crm/private/xml/Contacts/deleteRecords?"
    GET_FIELDS = "https://crm.zoho.com/crm/private/json/"

    def initialize(username, password)
      @username = username
      @password = password
    end

    def authenticate_user
      token_url = AUTH_URL + "EMAIL_ID=#{@username}&PASSWORD=#{@password}"
      response = HTTParty.post(token_url)
      response_body = response.body
      auth_info = Hash[response_body.split(" ").map { |str| str.split("=") }]
      auth_info["AUTHTOKEN"]
    end

    def retrieve_contacts(auth_token)
      all_contacts = GET_CONTACTS + "authtoken=#{auth_token}&scope=crmapi"
      HTTParty.get(all_contacts)
    end

    def retrieve_leads(auth_token)
      all_leads = GET_LEADS + "authtoken=#{auth_token}&scope=crmapi"
      HTTParty.get(all_leads)
    end

    def new_contact(auth_token, data)
      formatted_data = format_contacts(data)
      new_contact = NEW_CONTACT + "authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_contact)
    end

    def new_lead(auth_token, data)
      formatted_data = format_leads(data)
      new_lead = NEW_LEAD + "authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_lead)
    end

    def update_contact(auth_token, data, id)
      formatted_data = format_contacts(data)
      update_contact = UPDATE_CONTACT + "authtoken=#{auth_token}&scope=crmapi&newFormat=1&id=#{id}&xmlData=#{formatted_data}"
      HTTParty.put(update_contact)
    end

    def update_lead(auth_token, data, id)
      formatted_data = format_leads(data)
      update_lead = UPDATE_LEAD + "authtoken=#{auth_token}&scope=crmapi&newFormat=1&id=#{id}&xmlData=#{formatted_data}"
      HTTParty.put(update_lead)
    end

    def delete_contact(auth_token, id)
      delete_contact = DELETE_CONTACT + "authtoken=#{auth_token}&scope=crmapi&id=#{id}"
      HTTParty.delete(delete_contact)
    end

    def delete_lead(auth_token, id)
      delete_lead = DELETE_LEAD + "authtoken=#{auth_token}&scope=crmapi&id=#{id}"
      HTTParty.delete(delete_lead)
    end

    def get_fields(auth_token, module_name)
      name = module_name.capitalize
      fields = GET_FIELDS + name + "/getFields?authtoken=#{auth_token}&scope=crmap"
      HTTParty.get(fields)
    end

    private

    def format_contacts(info)
      data = "<Contacts><row no='1'>"
      info.each do |key, value|
        data += "<FL val='" + zohoify_key(key) + "'>" + value + "</FL>"
      end
      data += "</row></Contacts>"
    end

    def format_leads(info)
      data = "<Leads><row no='1'>"
      info.each do |key, value|
        data += "<FL val='" + zohoify_key(key) + "'>" + value + "</FL>"
      end
      data += "</row></Leads>"
    end

    def zohoify_key(key)
      key.to_s.gsub("_", " ").split.map(&:capitalize).join(' ')
    end

  end
end
