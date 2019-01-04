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
 * @description platform event common utilities tests
 * @group Test Layer
 */
@isTest
private class evt_PlatformEvtUtilitiesTest {
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';


	@isTest
	static void testnormalizeString() {
		String data = '  1221  ';
		String expected = '1221';
		String maxString = '';
		String result = evt_PlatformEvtUtilities.normalizeString(data, true, evt_PlatformEvtUtilities.MIN_STRING_SIZE);
		System.assertEquals(result, expected);
		result = evt_PlatformEvtUtilities.normalizeString(data, false, evt_PlatformEvtUtilities.MIN_STRING_SIZE);
		System.assertEquals(result, '  12');

		for (integer inx = 0; inx < evt_PlatformEvtUtilities.MAX_STRING_SIZE + 2; inx++) {
			maxString += 'a';
		}
		result = evt_PlatformEvtUtilities.normalizeString(maxString, true);
		System.assertEquals(result.length(), evt_PlatformEvtUtilities.MAX_STRING_SIZE);


	} // end of testnormalizeString

	@isTest
	static void testgetClassInstance() {
		Object obj = evt_PlatformEvtUtilities.getClassInstance('evt_PlatformEvtUtilities');
		System.assertEquals( obj != null , true);
		obj = evt_PlatformEvtUtilities.getClassInstance(null);
		System.assertEquals( obj == null , true);
	} // end of testgetClassInstance

	@isTest
	static void testensureEnviromentIsCorrectOtherwiseDebug() {
		String env = evt_PlatformEvtUtilities.ensureEnviromentIsCorrectOtherwiseDebug('evt_PlatformEvtUtilities');
		System.assertEquals( evt_PlatformEvtUtilities.DEBUG_ENVIRONMENT == env , true);
		env = evt_PlatformEvtUtilities.ensureEnviromentIsCorrectOtherwiseDebug(evt_PlatformEvtUtilities.TEST_ENVIRONMENT);
		System.assertEquals( evt_PlatformEvtUtilities.TEST_ENVIRONMENT == env , true);

	} // end of testensureEnviromentIsCorrectOtherwiseDebug
	@isTest
	static void testvalidEventName() {
		Boolean result = evt_PlatformEvtUtilities.validEventName('evt_PlatformEvtUtilities');
		System.assertEquals(false, result);
		result = evt_PlatformEvtUtilities.validEventName(ExceptedEventLabelInCustomMDT);
		System.assertEquals( true, result );
		result = evt_PlatformEvtUtilities.validEventName(null);
		System.assertEquals(false, result);

	} // end of testvalidEventName

	@isTest
	static void testgetSobjectName() {
		//assign
		String expected = 'Account';
		// act
		String result = evt_PlatformEvtUtilities.getSobjectName(new Account());
		// assert
		System.assertEquals(expected, result);
		// act
		result = evt_PlatformEvtUtilities.getSobjectName((List<SObject>)null);
		// assert
		System.assertEquals(true, result=='');
		// act
		result = evt_PlatformEvtUtilities.getSobjectName((SObject)null);
		// assert
		System.assertEquals(true, result=='');
	}
	@isTest
	static void testgetTypeFromSObjectCollectionWithNoContacts() {
		//assign
		List<SObject> sob = new List<Contact>();
		Type expected = Contact.class;
		// act
		Type ns = evt_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObjectCollectionContact
	@isTest
	static void testgetSobjectNameWithBadParams() {
		//assign
		String expected = '';
		SObject data = null;
		// act
		String result = evt_PlatformEvtUtilities.getSobjectName(data);
		// assert
		System.assertEquals(expected, result);
	} // end of testgetSobjectNameWithBadParams

	@isTest
	static void testgetSobjectNameWithList() {
		//assign
		String expected = 'Account';
		List<Account> alist = new List<Account> {
			new account(Name = 'Acme', Description = 'Acme Account')
		};
		insert alist;
		// act
		String result = evt_PlatformEvtUtilities.getSobjectName(alist);
		// assert
		System.assertEquals(expected, result);
	} // end of testgetSobjectName
	@isTest
	static void testgetTypeFromSObjectCollection() {
		//assign
		List<SObject> sob = new List<Contact> {
			new Contact()
			, new Contact()
		};
		Type expected = Contact.class;
		// act
		Type ns = evt_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObjectCollection

	@isTest
	static void testgetTypeFromSObject() {
		//assign
		SObject sob = new account(Name = 'Acme', Description = 'Acme Account');
		Type expected = Account.class;
		// act
		Type ns = evt_PlatformEvtUtilities.getTypeFromSObject(sob);
		// assert
		System.assertEquals(expected, ns);
	} // end of testgetTypeFromSObject

	@isTest
	static void testconvertDayToString() {
		//assign
		// act
		// assert
		System.assertEquals('01', evt_PlatformEvtUtilities.convertDayToString(1));
		System.assertEquals('01', evt_PlatformEvtUtilities.convertDayToString(0));
		System.assertEquals('31', evt_PlatformEvtUtilities.convertDayToString(32));
		System.assertEquals('31', evt_PlatformEvtUtilities.convertDayToString(31));
		System.assertEquals('30', evt_PlatformEvtUtilities.convertDayToString(30));
		System.assertEquals('10', evt_PlatformEvtUtilities.convertDayToString(10));
		System.assertEquals('12', evt_PlatformEvtUtilities.convertDayToString(12));
		System.assertEquals('21', evt_PlatformEvtUtilities.convertDayToString(21));
		System.assertEquals('15', evt_PlatformEvtUtilities.convertDayToString(15));
	}// end of testconvertDayToString

	@isTest
	static void testconvertMonthToString() {
		//assign
		// act
		// assert
		System.assertEquals('01', evt_PlatformEvtUtilities.convertMonthToString(1));
		System.assertEquals('01', evt_PlatformEvtUtilities.convertMonthToString(0));
		System.assertEquals('12', evt_PlatformEvtUtilities.convertMonthToString(32));
		System.assertEquals('12', evt_PlatformEvtUtilities.convertMonthToString(12));

		System.assertEquals('10', evt_PlatformEvtUtilities.convertMonthToString(10));
		System.assertEquals('01', evt_PlatformEvtUtilities.convertMonthToString(-1));
		System.assertEquals('02', evt_PlatformEvtUtilities.convertMonthToString(2));
		System.assertEquals('10', evt_PlatformEvtUtilities.convertMonthToString(10));
	}// end of convertMonthToString

	@isTest
	static void testgetDMLLimitsInStringForm() {
		//assign
		// act
		// assert
		System.assertEquals(true, evt_PlatformEvtUtilities.getDMLLimitsInStringForm() != null);
	}// end of testgetDMLLimitsInStringForm
	@isTest
	static void testformatForOutput() {
		//assign
		// act
		// assert
		System.assertEquals(true, evt_PlatformEvtUtilities.formatForOutput(LoggingLevel.DEBUG, 'test') != null );
	}// end of testformatForOutput
}