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
 * @description test the eprocess event handler
 * @group Test  Layer
 */
@isTest
private class evt_DefaultProcessEventHandlersTest {
	static List<String> names = new List<String> {
		evt_DefaultProcessHandler.DEFAULT_LOG_NAME
		, evt_DefaultProcessHandler.DEFAULT_ERROR_NAME
		, evt_DefaultProcessHandler.DEFAULT_SUCCESS_NAME
		, evt_DefaultProcessHandler.DEFAULT_ALERT_NAME
		, evt_DefaultProcessHandler.DEFAULT_STORE_NAME
	};
	@isTest
	static void defaultCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers();

		// assert
		system.assertEquals(5, evt_DefaultProcessEventHandlers.m_DefaultHandlers.size());
		for (String name : names) {
			system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName(name));
		}

	}
	@isTest
	static void oneParamCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(new  evt_DefaultProcessHandler('one'));

		// assert
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));


	}
	@isTest
	static void twoParamCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(
		    new  evt_DefaultProcessHandler('one')
		    , new evt_DefaultProcessHandler('two'));

		// assert
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('two'));


	}
	@isTest
	static void threeParamCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(
		    new  evt_DefaultProcessHandler('one')
		    , new evt_DefaultProcessHandler('two')
		    , new evt_DefaultProcessHandler('three'));

		// assert
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('three'));


	}
	@isTest
	static void fourParamCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(
		    new  evt_DefaultProcessHandler('one')
		    , new evt_DefaultProcessHandler('two')
		    , new evt_DefaultProcessHandler('three')
		    , new evt_DefaultProcessHandler('four'));

		// assert
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('four'));

	}
	@isTest
	static void fiveParamCtorTest() {
		// assign

		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(
		    new  evt_DefaultProcessHandler('one')
		    , new evt_DefaultProcessHandler('two')
		    , new evt_DefaultProcessHandler('three')
		    ,  new evt_DefaultProcessHandler('four')
		    ,  new evt_DefaultProcessHandler('five'));

		// assert
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('four'));
		system.assertNotEquals(null, evt_DefaultProcessEventHandlers.defaultHandlerByName('five'));

	}

	@isTest
	static void methodsAccessTest() {
		// assign
		evt_DefaultProcessHandler one = new evt_DefaultProcessHandler('one');
		evt_DefaultProcessHandler two = new evt_DefaultProcessHandler('two');
		evt_DefaultProcessHandler three = new evt_DefaultProcessHandler('three');
		evt_DefaultProcessHandler four = new evt_DefaultProcessHandler('four');
		evt_DefaultProcessHandler five = new evt_DefaultProcessHandler('five');
		// act
		evt_DefaultProcessEventHandlers ctor = new evt_DefaultProcessEventHandlers(
		    one, two, three, four, five);


		// assert
		system.assertEquals(one, evt_DefaultProcessEventHandlers.defaultHandlerByName('one'));
		system.assertEquals(two, evt_DefaultProcessEventHandlers.defaultHandlerByName('two'));
		system.assertEquals(three, evt_DefaultProcessEventHandlers.defaultHandlerByName('three'));
		system.assertEquals(four, evt_DefaultProcessEventHandlers.defaultHandlerByName('four'));
		system.assertEquals(five, evt_DefaultProcessEventHandlers.defaultHandlerByName('five'));

	}
}