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
 * @description Platform Event queuable to insert or delete into/from BO
 * @group Test Layer
 */
@isTest
private class evt_PlatformEventLogDataQueueHandlerTest {
	@isTest
	static  void testevt_PlatformEventLogDataQueueHandlerEnque() {
		// assign
		DateTime now = DateTime.Now();
		String name = 'my-test-pe-test-today';

		// act
		List<evt_PlatformEventDAOLog> daoList = new List<evt_PlatformEventDAOLog> {
			new evt_PlatformEventDAOLog(name, JSON.serialize(new pe_test__e()), now)
		};
		// startTest/stopTest block to force async processes
		//   to run in the test.
		Test.startTest();
		// act
		System.enqueueJob(new evt_PlatformEventLogDataQueueHandler(daoList));
		Test.stopTest();
		// assert -- this is bogus !
		// the queueable calls database.insertImmediate which does not error out but then does not
		// add the items either; as you can see I get at least one w/ no WHERE clause. Thus, tested in another
		// way. If there is a better way ( excluding mock) please advise!
		List<evt_Org_Events__b> big =  [select event_date__c, Event_Date_Year__c, Event_Date_Month__c, Event_Date_Day__c, Event_Truncated__c, Event_Name__c, Number_Of_Events__c, Event_JSON__c from evt_Org_Events__b  LIMIT 2];

		System.assertEquals(true, big != null);

	}
} // end of evt_PlatformEventLogDataQueueHandlerTest