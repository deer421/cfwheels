<cfcomponent output="false">

	<cffunction name="generatedKey" returntype="string" access="public" output="false">
		<cfreturn "identitycol">
	</cffunction>

	<cffunction name="randomOrder" returntype="string" access="public" output="false">
		<cfreturn "NEWID()">
	</cffunction>

	<cffunction name="getType" returntype="string" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		<cfscript>
			var loc = {};
			switch(arguments.type)
			{
				case "binary": case "timestamp": {loc.returnValue = "cf_sql_binary"; break;}
				case "bigint": {loc.returnValue = "cf_sql_bigint"; break;}
				case "bit": {loc.returnValue = "cf_sql_bit"; break;}
				case "char": case "nchar": case "uniqueidentifier": {loc.returnValue = "cf_sql_char"; break;}
				case "decimal": case "money": case "smallmoney": {loc.returnValue = "cf_sql_decimal"; break;}
				case "float": {loc.returnValue = "cf_sql_float"; break;}
				case "int": case "integer": {loc.returnValue = "cf_sql_integer";	break;}
				case "image": {loc.returnValue = "cf_sql_longvarbinary"; break;}
				case "text":	case "ntext": {loc.returnValue = "cf_sql_longvarchar";	break;}
				case "numeric":	{loc.returnValue = "cf_sql_numeric"; break;}
				case "real":	{loc.returnValue = "cf_sql_real"; break;}
				case "smallint":	{loc.returnValue = "cf_sql_smallint"; break;}
				case "datetime": case "smalldatetime": {loc.returnValue = "cf_sql_timestamp"; break;}
				case "tinyint":	{loc.returnValue = "cf_sql_tinyint"; break;}
				case "varbinary":	{loc.returnValue = "cf_sql_varbinary"; break;}
				case "varchar": case "nvarchar": {loc.returnValue = "cf_sql_varchar"; break;}
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>

	<cffunction name="query" returntype="struct" access="public" output="false">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="limit" type="numeric" required="false" default=0>
		<cfargument name="offset" type="numeric" required="false" default=0>
		<cfargument name="parameterize" type="any" required="true">
		<cfset var loc = StructNew()>
		<cfset var query = StructNew()>
		<cfset arguments.name = "query.name">
		<cfset arguments.result = "loc.result">
		<cfset arguments.datasource = application.settings.database.datasource>
		<cfset arguments.username = application.settings.database.username>
		<cfset arguments.password = application.settings.database.password>
		<cfset loc.sql = arguments.sql>
		<cfset loc.limit = arguments.limit>
		<cfset loc.offset = arguments.offset>
		<cfset loc.parameterize = arguments.parameterize>
		<cfset StructDelete(arguments, "sql")>
		<cfset StructDelete(arguments, "limit")>
		<cfset StructDelete(arguments, "offset")>
		<cfset StructDelete(arguments, "parameterize")>
		<!--- name="#arguments.name#" --->
		<cfquery attributeCollection="#arguments#"><cfloop array="#loc.sql#" index="loc.i"><cfif IsStruct(loc.i)><cfif (IsBoolean(loc.parameterize) AND loc.parameterize) OR (NOT IsBoolean(loc.parameterize) AND ListFindNoCase(loc.parameterize, loc.i.property))><cfqueryparam cfsqltype="#loc.i.type#" value="#loc.i.value#"><cfelse>'#loc.i.value#'</cfif><cfelse>#preserveSingleQuotes(loc.i)#</cfif>#chr(13)##chr(10)#</cfloop></cfquery>
		<cfset loc.returnValue.result = loc.result>
		<cfif StructKeyExists(query, "name")>
			<cfset loc.returnValue.query = query.name>
		</cfif>
		<cfreturn loc.returnValue>
	</cffunction>

</cfcomponent>