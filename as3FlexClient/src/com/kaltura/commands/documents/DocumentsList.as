package com.kaltura.commands.documents
{
	import com.kaltura.vo.KalturaDocumentEntryFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.documents.DocumentsListDelegate;
	import com.kaltura.net.KalturaCall;

	public class DocumentsList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaDocumentEntryFilter
		 * @param pager KalturaFilterPager
		 **/
		public function DocumentsList( filter : KalturaDocumentEntryFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'document_documents';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new DocumentsListDelegate( this , config );
		}
	}
}
