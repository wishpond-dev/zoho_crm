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
    NEW_CONTACTS = "https://crm.zoho.com/crm/private/xml/Contacts/insertRecords?"
    NEW_LEADS = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"
    UPDATE_CONTACTS = "https://crm.zoho.com/crm/private/xml/Contacts/updateRecords?"
    UPDATE_LEADS = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?"

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

    def retrieve_contacts(auth_token, from_index, to_index)
      all_contacts = GET_CONTACTS + "authtoken=#{auth_token}&scope=crmapi&fromIndex=#{from_index}&toIndex=#{to_index}"
      HTTParty.get(all_contacts)
    end

    def retrieve_leads(auth_token, from_index, to_index)
      all_leads = GET_LEADS + "authtoken=#{auth_token}&scope=crmapi&fromIndex=#{from_index}&toIndex=#{to_index}"
      HTTParty.get(all_leads)
    end

    def new_contact(auth_token, data)
      xml_data = format_contacts(data)
      formatted_data = escape_xml(xml_data)
      new_contact = NEW_CONTACT + "authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_contact)
    end

    def new_lead(auth_token, data)
      xml_data = format_leads(data)
      formatted_data = escape_xml(xml_data)
      new_lead = NEW_LEAD + "authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_lead)
    end

    def update_contact(auth_token, data, id)
      xml_data = format_contacts(data)
      formatted_data = escape_xml(xml_data)
      update_contact = UPDATE_CONTACT + "authtoken=#{auth_token}&scope=crmapi&newFormat=1&id=#{id}&xmlData=#{formatted_data}"
      HTTParty.put(update_contact)
    end

    def update_lead(auth_token, data, id)
      xml_data = format_leads(data)
      formatted_data = escape_xml(xml_data)
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

    def multiple_new_contacts(auth_token, data, number_of_records)
      xml_data = format_multiple_contacts(data, number_of_records)
      formatted_data = escape_xml(xml_data)
      new_contacts = NEW_CONTACTS + "newFormat=1&authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_contacts)
    end

    def multiple_new_leads(auth_token, data, number_of_records)
      xml_data = format_multiple_leads(data, number_of_records)
      formatted_data = escape_xml(xml_data)
      new_leads = NEW_LEADS + "newFormat=1&authtoken=#{auth_token}&scope=crmapi&xmlData=#{formatted_data}"
      HTTParty.post(new_leads)
    end

    def update_multiple_contacts(auth_token, data, number_of_records)
      xml_data = format_multiple_contacts(data, number_of_records)
      formatted_data = escape_xml(xml_data)
      update_contacts = UPDATE_CONTACTS + "authtoken=#{auth_token}&scope=crmapi&version=4&xmlData=#{formatted_data}"
      HTTParty.post(update_contacts)
    end

    def update_multiple_leads(auth_token, data, number_of_records)
      xml_data = format_multiple_leads(data, number_of_records)
      formatted_data = escape_xml(xml_data)
      update_leads = UPDATE_LEADS + "authtoken=#{auth_token}&scope=crmapi&version=4&xmlData=#{formatted_data}"
      HTTParty.post(update_leads)
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

    def format_multiple_contacts(info, number_of_records)
      data = "<Contacts>"
      row_num = 1
      info.each do |record|
        data += "<row no='#{row_num}'>"
        record.each do |key, value|
          data += "<FL val='" + zohoify_key(key) + "'>" + value + "</FL>"
        end
        data += "</row>"
        row_num += 1
      end
      data += "</Contacts>"
    end

    def format_multiple_leads(info, number_of_records)
      data = "<Leads>"
      row_num = 1
      info.each do |record|
        data += "<row no='#{row_num}'>"
        record.each do |key, value|
          data += "<FL val='" + zohoify_key(key) + "'>" + value + "</FL>"
        end
        data += "</row>"
        row_num += 1
      end
      data += "</Leads>"
    end

    def zohoify_key(key)
      key.to_s.gsub("_", " ").split.map(&:capitalize).join(' ')
    end

    def escape_xml(data)
      URI.escape(data)
    end

  end
end
