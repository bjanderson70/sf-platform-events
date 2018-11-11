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
 *
 * @author Bill Anderson
 * @description defines the default publisher tests
 * @group Test Layer
 */
@isTest
private class evt_DefaultPEPublisherTest {
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';

	//
	// test class used to excercise the default behavior
	//
	public class evt_PublisherTest extends evt_DefaultPEPublisher {
		public Boolean didHandle = false;
		public Boolean causeException = false;

		public evt_PublisherTest() {
			super(null);
		}
		public evt_PublisherTest(string evt) {

			super(evt);

		}
		public evt_PublisherTest(string evt, Boolean serialize) {

			super(evt, serialize);

		}
		protected override void handleCompletion(Object event
		        , Boolean state
		        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult
		        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData
		        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theLogData
		        , evt_PlatformEventAttrs attributes) {
			didHandle = true;
		}
		protected override integer processResults(List<Database.SaveResult> results
		        , List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult) {
			integer count = results.size();
			if ( causeException ) {
				throw new evt_PlatformEventException('For Testing');
			}
			return count;
		}

	}
	@isTest
	static void testBasicPublisherCtor() {
		// assign / act
		evt_PublisherTest publisher = new evt_PublisherTest();
		// assert
		System.assertEquals(true, publisher.handlerEventName() == null);

	}
	@isTest
	static void testBasicPublisherCtorWithTwoArguments() {
		// assign / act
		evt_PublisherTest publisher = new evt_PublisherTest(ExceptedEventLabelInCustomMDT, true);
		// assert
		System.assertEquals(true, publisher.handlerEventName() == ExceptedEventLabelInCustomMDT);
		System.assertEquals(true, publisher.serializeEvent);

	}
	@isTest
	static void testBasicPublisher() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		evt_PlatformEvtBuilder ctor = new evt_PlatformEvtBuilder(eventName, evt_PlatformEvtUtilities.TEST_ENVIRONMENT);
		evt_IEventHandler publisher = ctor.buildPublisher();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		evt_DefaultProcessEventHandlers handlers = new evt_DefaultProcessEventHandlers();
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();

		Test.startTest();
		// act
		// Publish test event
		result = publisher.process(evt, handlers, attrs);
		Test.getEventBus().deliver();
		Test.stopTest();

		// assert Verify results value
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.handlerException() == null);
		System.assertEquals(true, publisher.handlerEventName() != null);

	} // end of testBasicPublisher

	@isTest
	static void testPublisherTest() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		evt_PublisherTest publisher = new evt_PublisherTest(eventName);
		evt_DefaultProcessEventHandlers handlers = new evt_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();

		Test.startTest();
		// act - Publish test event
		result = publisher.process(evt, handlers, attrs);
		Test.getEventBus().deliver();
		Test.stopTest();

		// assert -- Verify SaveResult value
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.didHandle);
		System.assertEquals(true, publisher.theException == null);
	} // end of testPublisherTest

	@isTest
	static void testPublisherTestNoEvent() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result;
		evt_PublisherTest publisher = new evt_PublisherTest(eventName);
		evt_DefaultProcessEventHandlers handlers = new evt_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { };
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();

		Test.startTest();
		try {
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert --Verify results
		System.assertEquals(false, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.theException != null);
		System.assertEquals(false, publisher.didHandle);
	}// end of testPublisherTestNoEvent

	@isTest
	static void testPublisherTestEventButDifferentName() {
		// assign
		final String eventName = 'junk';
		Boolean result = true;
		evt_PublisherTest publisher = new evt_PublisherTest(eventName);
		evt_DefaultProcessEventHandlers handlers = new evt_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();

		Test.startTest();
		try {
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert -- Verify results
		System.assertEquals(false, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.theException != null);
		System.assertEquals(false, publisher.didHandle);
	} // end of testPublisherTestEventButDifferentName

	@isTest
	static void testPublisherTestWithException() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result = true, exceptionOccurred = false;
		evt_PublisherTest publisher = new evt_PublisherTest(eventName);

		evt_DefaultProcessEventHandlers handlers = new evt_DefaultProcessEventHandlers();
		List<SObject> evt = new List<SObject> { new pe_test__e()};
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();

		Test.startTest();
		try {
			publisher.causeException = true;
			// act -- Publish test event
			result = publisher.process(evt, handlers, attrs);
			Test.getEventBus().deliver();
		} catch (evt_PlatformEventException pexcp) {
			exceptionOccurred = true;
		} catch (Exception excp) {
			result = false;
		}
		Test.stopTest();

		// assert -- Verify results
		System.assertEquals(true, result);
		System.assertEquals(true, publisher.eventName == eventName);
		System.assertEquals(true, publisher.theException != null);
		System.assertEquals(true, exceptionOccurred);
	} // end of testPublisherTestWithException

	@isTest
	static void testprocessResults() {
		// assign
		final String eventName = ExceptedEventLabelInCustomMDT;
		Boolean result = true, exceptionOccurred = false;
		integer expected = 1;
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> errResult = new  List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		// Create two accounts, assuming the NAME is all that is required;
		// otherwise, this db insert is incorrect.

		evt_DefaultPEPublisher publisher = new evt_DefaultPEPublisher(eventName);

		// the goal is to have success and the count be equl to the results size (2) [as no errors]
		List<Account> sobjects = new List<Account> {
			new Account(Name = 'we'),
			new Account()
		};

		Database.SaveResult[] db_results = Database.insert(sobjects, false);

		integer count = publisher.processResults(db_results, errResult);

		System.assertEquals(expected, count);
		count = publisher.processResults(db_results, null);

		System.assertEquals(expected, count);


	} // end of testprocessResults

}