/**
 * Copyright (c) 2016-2018, Bill Anderson.  All rights reserved.
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
 * @author Bill Anderson
 * @description Platform Event Data Access Object to log
 * @group Logging Data Access Object
 */
public without sharing class evt_PlatformEventDAOLog {

	/////////////////////////////////////////////////////////////////////////
	// Data Members
	/////////////////////////////////////////////////////////////////////////

	protected String m_JsonData;
	protected String m_eventName;
	protected integer m_count;
	protected Datetime m_timestamp;
	protected Boolean m_truncated;

	/////////////////////////////////////////////////////////////////////////
	// Ctors
	/////////////////////////////////////////////////////////////////////////
	public evt_PlatformEventDAOLog(string name) {
		this(name, evt_PlatformEvtUtilities.EMPTY_JSON_s, Datetime.Now(), 1);
	} // end of ctor
	/**
	 * @brief ctor
	 * @description ctor
	 *
	 */
	public evt_PlatformEventDAOLog(string name, string json) {
		this(name, json, Datetime.Now(), 1);
	} // end of ctor
	/**
	* @brief ctor
	* @description ctor
	*
	*/
	public evt_PlatformEventDAOLog(string name, string json, Datetime timestamp ) {
		this(name, json, timestamp, 1);

	} // end of ctor
	/**
	* @brief ctor
	* @description ctor
	*
	*/
	public evt_PlatformEventDAOLog(string name, string json, integer eventCount ) {
		this(name, json, Datetime.Now(), eventCount);

	} // end of ctor
	/**
	* @brief ctor
	* @description ctor
	*
	*/
	public evt_PlatformEventDAOLog(string theName, string theJson, Datetime theTimestamp, integer eventCount ) {
		this.truncated = 0;
		this.timestamp = theTimestamp;
		// must be after truncated as the size may be truncated from property set
		this.json = theJson;
		this.name = string.isBlank(theName) ? this.timestamp.format() + evt_PlatformEvtUtilities.EVENT_TYPE_TAG_s : theName;
		this.count = eventCount < 0 ? 1 : eventCount;

	} // end of ctor


	/////////////////////////////////////////////////////////////////////////
	// Public Properties
	/////////////////////////////////////////////////////////////////////////

	public string name {
		get { return this.m_eventName;}
		private set { this.m_eventName = value;}
	} // end of name

	public string json {
		get { return this.m_JsonData;}
		protected set {
			this.m_JsonData = string.isBlank(value) ? evt_PlatformEvtUtilities.EMPTY_JSON_s : value;
			 
			// check the json data
			if ( this.m_JsonData.length() > evt_PlatformEvtUtilities.MAX_JSON_SIZE - 1 ) {
				this.m_JsonData = this.m_JsonData.Substring(0, evt_PlatformEvtUtilities.MAX_JSON_SIZE - 1);
				this.truncated = 1;
			}
		}
	}// end of json

	public integer truncated {
		get { return this.m_truncated ? 1 : 0;}
		protected set { this.m_truncated = value != 0 ? true : false;}
	} // end of truncated

	public DateTime timestamp {
		get { return this.m_timestamp;}
		protected set { this.m_timestamp = value == null ? Datetime.now() : value;}
	}// end of timestamp

	public integer count {
		get { return this.m_count;}
		protected set { this.m_count =  value ;}
	}// end of count

	public integer day {
		get { return this.m_timestamp.day();}
	} // end of day
	public integer month {
		get { return this.m_timestamp.month();}
	}// end of month

	public integer year {
		get { return this.m_timestamp.year();}
	}// end of year

	/////////////////////////////////////////////////////////////////////////
	// Public Methods
	/////////////////////////////////////////////////////////////////////////

	/**
	 * @description map from big objects
	 *
	 * @param entries collection of evt_PlatformEventDAOLog
	 * @return collection of evt_Org_Events__b
	 */
	public static List<evt_Org_Events__b> mapFrom(List<evt_PlatformEventDAOLog> entries) {
		List<evt_Org_Events__b> results = new List<evt_Org_Events__b>();
		if ( entries != null && entries.size() > 0) {
			for (evt_PlatformEventDAOLog item : entries) {

				results.add(new evt_Org_Events__b(
				                Event_Name__c = item.name,
				                Event_Date__c =  item.timestamp,
				                Event_Date_Day__c = item.timestamp.day(),
				                Event_Date_Month__c = item.timestamp.month(),
				                Event_Date_Year__c = item.timestamp.year(),
				                Event_Json__c =  item.json,
				                Event_Truncated__c = item.truncated,
				                Number_Of_Events__c = item.count
				            )
				           );

			}
		}

		return results;
	}// end of mapFrom
	/**
	 * @description map from big objects
	 *
	 * @param entries collection of evt_Org_Events__b
	 * @return collection of evt_PlatformEventDAOLog
	 */
	public static List<evt_PlatformEventDAOLog> mapFrom(List<evt_Org_Events__b> entries) {
		List<evt_PlatformEventDAOLog> results = new List<evt_PlatformEventDAOLog>();
		if ( entries != null && entries.size() > 0) {
			for (evt_Org_Events__b item : entries) {

				results.add(new evt_PlatformEventDAOLog(
				                item.Event_Name__c,
				                item.Event_Json__c,
				                item.Event_Date__c,
				                item.Number_Of_Events__c == null ? 1 : (integer)item.Number_Of_Events__c
				            )
				           );
			}
		}

		return results;
	} // end of mapFrom

} // end of evt_PlatformEventDAOLog