/**
 * Encapsulates all behaviour logic relating to the
 *
 * For more guidelines and details see
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Domain_Layer
 * @group Domain Layer
 **/
/**
 * Copyright (c) 2016-2018, Bill Anderson.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill Anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * @author Bill Anderson
 * @description platform event custom MDT data model (DAO)
 * @group Common Layer
 */
public virtual without sharing class evt_PlatformEvtMdtDataModel {

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Data Members
	//
	/////////////////////////////////////////////////////////////////////////////////////////

	public static final String All_s = 'All';
	public static final String WHERE_s = ' WHERE ';
	public static final String FROM_s = ' FROM ';
	public static final String SELECT_s = ' SELECT ';
	public static final String CACHE_KEY_SEPARATOR_s = '.';

	public static final String DefaultProcessHandlerClass = 'evt_DefaultProcessHandler';
	public static final String DefaultPublisherClass = 'evt_DefaultPEPublisher';
	public static final String DefaultConsumerClass = 'evt_DefaultPEConsumer';
	/**
	 * @description data cache information - view representation , allows for changes
	 * in the implementation (data representation) w/o affecting the consumption
	 *
	 */
	public virtual class PEDataModelInformation {
		public String label;
		public String namespacePrefix;
		public String developerName;
		// specific to platform events
		public String environment;
		public String successHandlerClass;
		public String logHandlerClass;
		public String errorHandlerClass;
		public String alertHandlerClass;
		public String storeHandlerClass;
		public String publisherClass;
		public String consumerClass;
		public Boolean serializeEvent;
		public Boolean isActive;
		public Boolean allowRetry;
	} // end of  PEDataModelInformation
	/**
	 * This enum is used to control the search parameters
	 * (protected is NOT ALLOW!)
	 */
	public enum evt_ControlPolicySearchEnum {
		byLabel,            // by label
		byName,             // by name
		byEnvironmentAndLabel  // by environment

	} // end of evt_ControlPolicySearchEnum

	// the custom mdt name
	@TestVisible
	static private final string MDT_Name = 'evt_Platform_Event_Binding__mdt';
	// fields supported on this custom mdt
	// Step 1a. Add field name here, ie. 'LogFormatter__c'
	@TestVisible
	static private final List<String> FieldList = new List<String> {
		'Environment__c'
		, 'Consumer__c'
		, 'Publisher__c'
		, 'Alert_Handler__c'
		, 'Error_Handler__c'
		, 'Log_Handler__c'
		, 'Success_Handler__c'
		, 'Serialize_Event__c'
		, 'Store_Handler__c'
		, 'Active__c'
		, 'Allow_Consumer_Retry__c'

	};
	// for caching locally, stored in section 'evt_PlatformEvtMdtDataModel'
	@TestVisible
	static final Map<String, Object> l1Cache = new  Map<String, Object> ();
	// acts as the environment
	static final String CUSTOM_MDT_ENVIRONMENT = 'Environment__c';
	// custom mdt name
	@TestVisible
	static final String CUSTOM_MDT_NAME = 'DeveloperName';
	// custom mdt label
	@TestVisible
	static final String CUSTOM_MDT_LABEL =  'Label';
	// custom mdt select fields for common custom mdt fields
	@TestVisible
	static final String CUSTOM_MDT_FIELDS = 'DeveloperName, Id, Label, MasterLabel, NamespacePrefix, QualifiedApiName';
	// the selected fields query
	@TestVisible
	static final String SELECT_FIELDS = SELECT_s + CUSTOM_MDT_FIELDS;
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Properties
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description the custom mdt name
	 *
	 * @param value the custom mdt name
	 * @return the custom mdt name
	 */
	public String CustomMDTName { get; private set;}
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// CTORS
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description ctor
	 *
	 */
	public evt_PlatformEvtMdtDataModel() {
		this.CustomMDTName = evt_PlatformEvtMdtDataModel.MDT_Name;
	} // end of ctor
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// PUBLIC METHODS
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description  find all items
	 *
	 * @return the list of informaiton
	 */
	public List<PEDataModelInformation> findAll() {
		return this.getInformationByLookup(evt_PlatformEvtMdtDataModel.All_s, evt_ControlPolicySearchEnum.byLabel);
	} // end of findAll
	/**
	* @description find by environment
	*
	* @param string the environment / namespace
	* @return the model informaiton
	*/
	public List<PEDataModelInformation> findByEnvironment(String environment) {
		return this.getInformationByLookup(environment, null, evt_ControlPolicySearchEnum.byLabel);
	}// end of findByEnvironment
	/**
	 * @description find by environment and label
	 *
	 * @param string the environment / namespace
	 * @param string the label name
	 * @return the model informaiton
	 */
	public List<PEDataModelInformation> findbyEnvironmentAndLabel(String environment, String labelName) {
		List<PEDataModelInformation> result = null;
		// must have a valid name
		if ( !string.isBlank(labelName) ) {
			if ( string.isBlank(environment)) {
				result = this.getInformationByLookup(labelName, evt_ControlPolicySearchEnum.byLabel);
			} else {
				result = this.getInformationByLookup(environment, labelName, evt_ControlPolicySearchEnum.byLabel);
			}
		} else if ( !string.isBlank(environment) ) {
			result = this.findByEnvironment(environment);
		}
		return result;

	} // end of findbyEnvironmentAndLabel
	/**
	 * @description find by label
	 *
	 * @param labelName the label name
	 * @return the  informaiton
	 */
	public List<PEDataModelInformation> findByLabel(String labelName) {
		return this.findbyEnvironmentAndLabel(null, labelName);
	} // end of findByLabel

	/**
	 * @description find by name
	 *
	 * @param labelName the  name
	 * @return the informaiton
	 */
	public List<PEDataModelInformation> findByName(String name) {
		List<PEDataModelInformation> result = null;
		if ( string.isBlank(name)) {
			return result;
		}
		return this.getInformationByLookup(name, evt_ControlPolicySearchEnum.byName);

	} // end of findByName

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// Protected Methods
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description populates ALL data from the custom mdt
	 *
	 * @param mdt custom MDT
	 * @return data representation of the custom metadata type
	 */
	@TestVisible
	protected virtual List<PEDataModelInformation> populateFromDataObjectChild(List<SObject> mdt) {
		List<PEDataModelInformation> results = new List<PEDataModelInformation> ();
		List<evt_Platform_Event_Binding__mdt> cmdts = (List<evt_Platform_Event_Binding__mdt>) mdt;


		if (cmdts != null && cmdts.size() > 0) {

			for (evt_Platform_Event_Binding__mdt cmdt : cmdts) {
				PEDataModelInformation result = new PEDataModelInformation();
				// set common mdt values
				this.setValues(result, cmdt.Label, cmdt.NamespacePrefix, cmdt.DeveloperName);

				/* Set Data platform event **/

				result.storeHandlerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Store_Handler__c, evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass);
				result.alertHandlerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Alert_Handler__c, evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass);
				result.consumerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Consumer__c, evt_PlatformEvtMdtDataModel.DefaultConsumerClass);
				result.publisherClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Publisher__c, evt_PlatformEvtMdtDataModel.DefaultPublisherClass);
				result.environment = evt_PlatformEvtUtilities.normalizeString(cmdt.Environment__c, true);
				result.errorHandlerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Error_Handler__c, evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass);
				result.logHandlerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Log_Handler__c, evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass);
				result.successHandlerClass = evt_PlatformEvtMdtDataModel.defaultProcessHandler(cmdt.Success_Handler__c, evt_PlatformEvtMdtDataModel.DefaultProcessHandlerClass);
				result.serializeEvent = cmdt.Serialize_Event__c;
				result.isActive = cmdt.Active__c;
				result.allowRetry = cmdt.Allow_Consumer_Retry__c;

				results.add(result);
			}
		} // endif

		return results;
	} // end of populateFromDataObjectChild
	/**
	 * @description return their custom fields to select
	 * @return collection of field name
	 */
	@TestVisible
	protected virtual List<String> getSelectFields() {
		return evt_PlatformEvtMdtDataModel.FieldList;
	} // end of getSelectFields

	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// PROTECTED METHODS
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description find the custom mdt
	 *
	 * @param lookup lookup string
	 * @param evt_ControlPolicySearchEnum how to search
	 *
	 * @return the data model
	 */
	@TestVisible
	protected List<PEDataModelInformation> getInformationByLookup(String lookup, evt_ControlPolicySearchEnum controlType) {
		return this.getInformationByLookup(null, lookup, controlType);
	} // end of getInformationByLookup
	/**
	* @description find the custom mdt
	*
	* @param environment/namespace
	* @param lookup lookup string
	* @param evt_ControlPolicySearchEnum how to search
	*
	* @return the data model
	*/
	@TestVisible
	protected List<PEDataModelInformation> getInformationByLookup(String environment, String lookup, evt_ControlPolicySearchEnum controlType) {
		List<SObject> cmdt = null;
		String selector = this.makeSoqlSelect();
		string key = this.makeCacheKey(environment, lookup);

		// check out local cache to save some time
		List<PEDataModelInformation> result =  (List<PEDataModelInformation>)l1Cache.get(key);
	 
		try {
			// still no data?
			if ( result == null ) {
				Boolean theControlType = controlType == evt_ControlPolicySearchEnum.byName;
				String theQueryType = theControlType ? CUSTOM_MDT_NAME : CUSTOM_MDT_LABEL;
				// preform query
				cmdt = this.queryCustomMDT(selector, theQueryType, lookup, environment);
				// any data to process
				if ( cmdt != null && cmdt.size() > 0) {
					result = this.populateFrom(cmdt);
					if ( result != null ) {
						// let child populate information and place in local cache
						l1Cache.put(key, result);
					}
				}
			}
		} catch (Exception excp) {
			// process exception
			evt_PlatformEventLogger.myInstance().log('+++ EXCEPTION +++ evt_PlatformEvtMdtDataModel.getInformationByLookup: ' + excp.getMessage());
		}
		 
		return result;
	} // end of getInformationByLookup

	/**
	 * @description populate DAO's values
	 *
	 * @param result DAO of the base
	 * @param lbl mdt label
	 * @param prefix namespace prefix
	 * @param name developer name
	 */
	@TestVisible
	protected void setValues(PEDataModelInformation result, string lbl, string prefix, string name) {
		result.label = evt_PlatformEvtUtilities.normalizeString(lbl, true);
		result.namespacePrefix = evt_PlatformEvtUtilities.normalizeString(prefix, true);
		result.developerName = evt_PlatformEvtUtilities.normalizeString(name, true);
	} // end of setValues
	/////////////////////////////////////////////////////////////////////////////////////////
	//
	// PRIVATE METHODS
	//
	/////////////////////////////////////////////////////////////////////////////////////////
	/**
	 * @description make key for the cache
	 *
	 * @param environment the environment (debug, production, etc.)
	 * @param lookup  how to find the value
	 *
	 * @return the key associate with the appropriate custom metadata
	 */
	@TestVisible
	private string makeCacheKey(string environment, string lookup) {
		return evt_PlatformEvtMdtDataModel.makeLocalCacheKey(this.CustomMDTName , evt_PlatformEvtMdtDataModel.makeLocalCacheKey(environment, lookup));
	} // end of makeCacheKey
	/**
	 * @description populate our external view of the data cache structure
	 *
	 * @param cacheMDT the data cache Metadata
	 * @return our view of the data ( allows us to change internally)
	 */
	@TestVisible
	private List<PEDataModelInformation> populateFrom(List<SObject> mdt) {
		List<PEDataModelInformation> result = null;
		if ( mdt != null ) {
			result = this.populateFromDataObjectChild(mdt);
		}

		return result;
	} // end of populateFrom

	/**
	 * @description create the soql select clause
	 * @return the select clause
	 */
	@TestVisible
	private String makeSoqlSelect() {
		String result =  SELECT_FIELDS;

		List<String> childList = this.getSelectFields();
		if ( childList != null && childList.size() > 0) {
			result += ',' + String.join( childList, ',');
		}

		return result;
	} // end of makeSoqlSelect
	/**
	 * @description query for the Custom MDT
	 *
	 * @param selectClause the select clause
	 * @param byValue the value (name or label)
	 * @param theValue the actual value
	 * @return the found SObject
	 */
	@TestVisible
	private List<SObject> queryCustomMDT(String selectClause,
	                                     String byValue,
	                                     String theValue,
	                                     String environment) {

		String myValue = theValue;
		String clause = selectClause + evt_PlatformEvtMdtDataModel.FROM_s + this.customMDTName;

		if ( !string.isBlank(environment) ) {
			if (  !string.isBlank(myValue)) {
				if ( environment != evt_PlatformEvtMdtDataModel.All_s) {
					clause +=  evt_PlatformEvtMdtDataModel.WHERE_s
					           + byValue + ' = :myValue '
					           + ' AND '
					           + CUSTOM_MDT_ENVIRONMENT + ' = :environment';
				} else {
					clause +=  evt_PlatformEvtMdtDataModel.WHERE_s
					           + byValue + ' = :myValue ';
				}
			} else if (environment != evt_PlatformEvtMdtDataModel.All_s ) {
				clause +=  evt_PlatformEvtMdtDataModel.WHERE_s
				           + CUSTOM_MDT_ENVIRONMENT + ' = :environment';
			}
			// are we getting ALL items or not
		}  else if ( myValue != evt_PlatformEvtMdtDataModel.All_s ) {
			clause +=  evt_PlatformEvtMdtDataModel.WHERE_s
			           + byValue + ' = : myValue';
		}

		// get the results
		return Database.query(String.escapeSingleQuotes(clause));

	} // end of queryCustomMDT

	/**
	* @description make the local cache key
	*
	* @param String local cache environment
	* @param String local cache label
	*
	* @return string local cache key
	*/
	@TestVisible
	private static string makeLocalCacheKey(String environment, String label) {
		String partition = string.isBlank(environment) ? '' : environment;
		if ( !string.isBlank(label) ) {
			if (!string.isBlank(partition) ) {
				partition = partition + CACHE_KEY_SEPARATOR_s + label;
			} else {
				partition = label;
			}
		}
		return partition;
	} // end of makeLocalCacheKey

	/**
	 * @description ensure there is a class (not checking misspellings!!)
	 *
	 * @param datum value of the class
	 * @param defaultClass default class name if not defined
	 * @return valid class
	 */
	@TestVisible
	private static string defaultProcessHandler(String datum, String defaultClass) {
		String result = evt_PlatformEvtUtilities.normalizeString(datum, true);
		if ( string.isBlank(result) ) {
			result = defaultClass;
		}
		return result;
	} // end of defaultProcessHandler
} // end of evt_PlatformEvtMdtDataModel