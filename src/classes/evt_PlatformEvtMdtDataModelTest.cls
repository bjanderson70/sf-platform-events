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
 * @description platform event custom MDT data model (DAO) Tests
 * @group Test Layer
 */
@isTest
private class evt_PlatformEvtMdtDataModelTest {
	// This test event MUST BE PRESENT
	static final String ExceptedEventLabelInCustomMDT = 'pe_test__e';
	static final String ExceptedEventNameInCustomMDT = 'pe_test_e';


	@isTest
	static void testCtor() {
		// assign/act
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// assert
		system.assertEquals(evt_PlatformEvtMdtDataModel.MDT_Name,
		                    ctor.CustomMDTName);

	} // end of testCtor

	@isTest
	static void testfindAll() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findAll();
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindAll

	@isTest
	static void testfindbyEnvironmentAndLabelWithNullLabel() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findbyEnvironmentAndLabel(evt_PlatformEvtUtilities.TEST_ENVIRONMENT, null);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindbyEnvironmentAndLabelWithNullLabel

	@isTest
	static void testfindEnvironment() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByEnvironment(evt_PlatformEvtUtilities.TEST_ENVIRONMENT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	} // end of testfindEnvironment
	@isTest
	static void testfindbyEnvironmentAndLabel() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findbyEnvironmentAndLabel(evt_PlatformEvtUtilities.TEST_ENVIRONMENT
		        , ExceptedEventLabelInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);
		system.assertEquals(true, result[0].isActive==true);
	}
	@isTest
	static void testfindByLabel() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		//act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByLabel(ExceptedEventLabelInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByLabel

	@isTest
	static void testfindByName() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByName(ExceptedEventNameInCustomMDT);
		// assert
		system.assertEquals(false, result == null);
		system.assertEquals(true, result.size() > 0);

	}// end of testfindByName
	@isTest
	static void testfindByNameWithNull() {
		// assign
		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		// act
		List<evt_PlatformEvtMdtDataModel.PEDataModelInformation> result = ctor.findByName(null);
		// assert
		system.assertEquals(true, result == null);

	}// end of testfindByNameWithNull

	@isTest
	static void testdefaultProcessHandler() {
		// assign/act
		String result = evt_PlatformEvtMdtDataModel.defaultProcessHandler(null, 'no');
		// assert
		system.assertEquals(true, result == 'no');
	}

	@isTest
	static void testsetValues() {
		// assign
		evt_PlatformEvtMdtDataModel.PEDataModelInformation info = new evt_PlatformEvtMdtDataModel.PEDataModelInformation();
		String seed = '';

		evt_PlatformEvtMdtDataModel ctor = new evt_PlatformEvtMdtDataModel();
		for (integer inx = 0; inx < evt_PlatformEvtMdtDataModel.MAX_STRING_SIZE; inx++) {
			seed += '*';
		}
		// act
		ctor.setValues(info, 'testLabel' + seed, 'testns' + seed, 'testDevName' + seed);
		// assert
		system.assertEquals(info.label.length(), evt_PlatformEvtMdtDataModel.MAX_STRING_SIZE );
		system.assertEquals(info.namespacePrefix.length(), evt_PlatformEvtMdtDataModel.MAX_STRING_SIZE);
		system.assertEquals(info.developerName.length(), evt_PlatformEvtMdtDataModel.MAX_STRING_SIZE);
		system.assertEquals(info.developerName.startsWith('testDevName'), true);

	} // end of testsetValues
}