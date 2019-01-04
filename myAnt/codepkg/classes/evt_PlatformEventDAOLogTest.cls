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
 * @description Platform Event Data Access Object to test
 * @group Test Layer
 */
@isTest
private class evt_PlatformEventDAOLogTest {

	@isTest
	static void nameCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json == evt_PlatformEvtUtilities.EMPTY_JSON_s);
		System.assertEquals(0, ctor.truncated);
		System.assertEquals(true, ctor.timestamp != null);
		System.assertEquals(1, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);

	} // end of nameCtor
	@isTest
	static void nameAndJsonCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		String json = '{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}';

		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name, json);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json == json);
		System.assertEquals(0, ctor.truncated);
		System.assertEquals(true, ctor.timestamp != null);
		System.assertEquals(1, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);

	} // end of nameAndJsonCtor
	@isTest
	static void nameAndBadJsonCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		String json = null;

		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name, json);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json == evt_PlatformEvtUtilities.EMPTY_JSON_s);
		System.assertEquals(0, ctor.truncated);
		System.assertEquals(true, ctor.timestamp != null);
		System.assertEquals(1, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);

	} // end of nameAndBadJsonCtor

	@isTest
	static void nameAndJsonAndTSCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		String json = '{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}';

		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name, json, now);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json == json);
		System.assertEquals(0, ctor.truncated);
		System.assertEquals(true, ctor.timestamp == now);
		System.assertEquals(1, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);

	} // end of nameAndJsonAndTSCtor
	@isTest
	static void nameAndJsonAndCountCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		String json = '{"success":false,"errors":[{"message":"You fool what are you doing...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}';

		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name, json, 2);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json == json);
		System.assertEquals(0, ctor.truncated);
		System.assertEquals(true, ctor.timestamp != null);
		System.assertEquals(2, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);

	} // end of nameAndJsonAndCountCtor

	@isTest
	static void testWithTruncationCtor() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'pe_test';
		String json = evt_PlatformEventDAOLogTest.generateLargeString(evt_PlatformEvtUtilities.MAX_JSON_SIZE + 10);
		// act
		evt_PlatformEventDAOLog ctor = new evt_PlatformEventDAOLog(name, json, 1);
		// assert
		System.assertEquals(true, ctor.name == name);
		System.assertEquals(true, ctor.json != json);
		System.assertEquals(1, ctor.truncated);
		System.assertEquals(true, ctor.timestamp != null);
		System.assertEquals(1, ctor.count);
		System.assertEquals(now.day(), ctor.day);
		System.assertEquals(now.month(), ctor.month);
		System.assertEquals(now.year(), ctor.year);
	} // end of testWithTruncationCtor

	@isTest
	static void testmapFromBigObject() {
		// assign
		List<evt_Org_Events__b> items = new List<evt_Org_Events__b>();
		integer day = 1, month = 1, year = 2019;
		for ( integer inx = 0; inx < 2; inx++) {
			items.add(new evt_Org_Events__b (Event_Date__c = date.newinstance(year, month, day + inx),
			                                 Event_Date_Day__c = day + inx,
			                                 Event_Json__c = JSON.serialize(new pe_test__e()),
			                                 Event_Date_Month__c = month,
			                                 Event_Name__c = 'pe_test__e',
			                                 Event_Truncated__c = 0,
			                                 Event_Date_Year__c = year,
			                                 Number_Of_Events__c = 1));

		}
		// act
		List<evt_PlatformEventDAOLog> result = evt_PlatformEventDAOLog.mapFrom(items);
		// assert
		System.assertEquals(items.size() , result.size());
		for ( integer inx = 0; inx < result.size(); inx++) {
			System.assertEquals(items[inx].Number_Of_Events__c , result[inx].count);
			System.assertEquals(items[inx].Event_Name__c , result[inx].name);
		}

	}// end of testmapFromBigObject

	@isTest
	static void testmapFromLocalObject() {
		// assign
		List<evt_PlatformEventDAOLog> items = new List<evt_PlatformEventDAOLog>();
		DateTime now = DateTime.Now();
		String name = 'pe_test',
		       json = '{test}';

		for ( integer inx = 0; inx < 2; inx++) {
			items.add(new evt_PlatformEventDAOLog(name, json, 2));

		}
		// act
		List<evt_Org_Events__b> result = evt_PlatformEventDAOLog.mapFrom(items);
		// assert
		System.assertEquals(items.size() , result.size());
		for ( integer inx = 0; inx < result.size(); inx++) {
			System.assertEquals(items[inx].count, result[inx].Number_Of_Events__c);
			System.assertEquals(items[inx].name, result[inx].Event_Name__c);
			System.assertEquals(items[inx].json, result[inx].Event_Json__c);
		}

	}// end of testmapFromLocalObject

	public static  String generateLargeString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String randStr = '';

		while (randStr.length() < len) {
			randStr += chars;
		}

		return randStr;
	} // end of generateLargeString

} // end of evt_PlatformEventDAOLogTest