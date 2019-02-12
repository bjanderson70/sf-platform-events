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
 * @description defines a store handler to test
 * @group Test Layer
 */
@isTest
private class evt_DefaultProcessStoreHandlerTest {
	@isTest
	static void testCtorevt_DefaultProcessStoreHandler() {
		// assign / act
		evt_DefaultProcessStoreHandler ctor = new evt_DefaultProcessStoreHandler();

		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == evt_DefaultProcessHandler.DEFAULT_STORE_NAME);
		System.assertEquals(true, ctor.toString() != null);
	}

	@isTest
	static void testCtorevt_DefaultProcessStoreHandlerWithName() {
		// assign
		String name = 'mylog';
		// act
		evt_DefaultProcessStoreHandler ctor = new evt_DefaultProcessStoreHandler(name);

		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, ctor.toString() != null);
	}

	@isTest
	static void testchildProcess() {
		// assign
		String name = 'mylog';
		evt_PlatformEventAttrs attrs = new evt_PlatformEventAttrs();
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> param = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> {
			new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('thename')
			, new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata')
			, new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc')
			, new evt_DefaultPlatformEvent.PlatformEvtResultPOAC('thename', 'thedata', 'misc', 10)
		};
		evt_DefaultProcessStoreHandler ctor = new evt_DefaultProcessStoreHandler(name);
		// act
		String result =	(String)ctor.childProcess(param, attrs);
		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, result != null);
	}

	@isTest
	static void testchildProcessWithBadParam() {
		// assign
		String name = 'mylog';


		evt_DefaultProcessStoreHandler ctor = new evt_DefaultProcessStoreHandler(name);
		// act
		String result =	(String)ctor.childProcess(null, null);

		// assert
		System.assertEquals(true, ctor != null);
		System.assertEquals(true, ctor.handlerName() == name);
		System.assertEquals(true, ctor.handlerException() != null);
	}

	@isTest
	static void testgetEventInformation() {

		// assign
		String evtName = 'pe_test__e';
		List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC> theData = new List<evt_DefaultPlatformEvent.PlatformEvtResultPOAC>();
		List<pe_Test__e> collectionOfEvents = new List<pe_Test__e> { new pe_test__e()};
		evt_DefaultPlatformEvent pe = new evt_DefaultPlatformEvent(evtName);

		pe.serializeEventData(theData, collectionOfEvents);
		// act
		List<evt_PlatformEventDAOLog> result  = evt_DefaultProcessStoreHandler.getEventInformation(theData);
		// assert

		System.assertEquals(true, result.size() > 0);

	}
}