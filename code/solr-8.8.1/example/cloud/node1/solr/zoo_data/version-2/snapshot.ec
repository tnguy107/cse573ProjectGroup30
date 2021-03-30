ZKSN   ��������                       world   anyone                world   anyone        ��������                                       
                   �   /configs����                       xMPF�  xMPF�                             /configs/_default����                       xMPF�  xMPF�                          �    /configs/_default/managed-schema  �Z<?xml version="1.0" encoding="UTF-8" ?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

<!--

 This example schema is the recommended starting point for users.
 It should be kept correct and concise, usable out-of-the-box.


 For more information, on how to customize this file, please see
 http://lucene.apache.org/solr/guide/documents-fields-and-schema-design.html

 PERFORMANCE NOTE: this schema includes many optional features and should not
 be used for benchmarking.  To improve performance one could
  - set stored="false" for all fields possible (esp large fields) when you
    only need to search on the field but don't need to return the original
    value.
  - set indexed="false" if you don't need to search on the field, but only
    return the field as a result of searching on other indexed fields.
  - remove all unneeded copyField statements
  - for best index size and searching performance, set "index" to false
    for all general text fields, use copyField to copy them to the
    catchall "text" field, and use that for searching.
-->

<schema name="default-config" version="1.6">
    <!-- attribute "name" is the name of this schema and is only used for display purposes.
       version="x.y" is Solr's version number for the schema syntax and 
       semantics.  It should not normally be changed by applications.

       1.0: multiValued attribute did not exist, all fields are multiValued 
            by nature
       1.1: multiValued attribute introduced, false by default 
       1.2: omitTermFreqAndPositions attribute introduced, true by default 
            except for text fields.
       1.3: removed optional field compress feature
       1.4: autoGeneratePhraseQueries attribute introduced to drive QueryParser
            behavior when a single string produces multiple tokens.  Defaults 
            to off for version >= 1.4
       1.5: omitNorms defaults to true for primitive field types 
            (int, float, boolean, string...)
       1.6: useDocValuesAsStored defaults to true.
    -->

    <!-- Valid attributes for fields:
     name: mandatory - the name for the field
     type: mandatory - the name of a field type from the 
       fieldTypes section
     indexed: true if this field should be indexed (searchable or sortable)
     stored: true if this field should be retrievable
     docValues: true if this field should have doc values. Doc Values is
       recommended (required, if you are using *Point fields) for faceting,
       grouping, sorting and function queries. Doc Values will make the index
       faster to load, more NRT-friendly and more memory-efficient. 
       They are currently only supported by StrField, UUIDField, all 
       *PointFields, and depending on the field type, they might require
       the field to be single-valued, be required or have a default value
       (check the documentation of the field type you're interested in for
       more information)
     multiValued: true if this field may contain multiple values per document
     omitNorms: (expert) set to true to omit the norms associated with
       this field (this disables length normalization and index-time
       boosting for the field, and saves some memory).  Only full-text
       fields or fields that need an index-time boost need norms.
       Norms are omitted for primitive (non-analyzed) types by default.
     termVectors: [false] set to true to store the term vector for a
       given field.
       When using MoreLikeThis, fields used for similarity should be
       stored for best performance.
     termPositions: Store position information with the term vector.  
       This will increase storage costs.
     termOffsets: Store offset information with the term vector. This 
       will increase storage costs.
     required: The field is required.  It will throw an error if the
       value does not exist
     default: a value that should be used if no value is specified
       when adding a document.
    -->

    <!-- field names should consist of alphanumeric or underscore characters only and
      not start with a digit.  This is not currently strictly enforced,
      but other field names will not have first class support from all components
      and back compatibility is not guaranteed.  Names with both leading and
      trailing underscores (e.g. _version_) are reserved.
    -->

    <!-- In this _default configset, only four fields are pre-declared:
         id, _version_, and _text_ and _root_. All other fields will be type guessed and added via the
         "add-unknown-fields-to-the-schema" update request processor chain declared in solrconfig.xml.
         
         Note that many dynamic fields are also defined - you can use them to specify a 
         field's type via field naming conventions - see below.
  
         WARNING: The _text_ catch-all field will significantly increase your index size.
         If you don't need it, consider removing it and the corresponding copyField directive.
    -->

    <field name="id" type="string" indexed="true" stored="true" required="true" multiValued="false" />
    <!-- docValues are enabled by default for long type so we don't need to index the version field  -->
    <field name="_version_" type="plong" indexed="false" stored="false"/>

    <!-- If you don't use child/nested documents, then you should remove the next two fields:  -->
    <!-- for nested documents (minimal; points to root document) -->
    <field name="_root_" type="string" indexed="true" stored="false" docValues="false" />
    <!-- for nested documents (relationship tracking) -->
    <field name="_nest_path_" type="_nest_path_" /><fieldType name="_nest_path_" class="solr.NestPathField" />

    <field name="_text_" type="text_general" indexed="true" stored="false" multiValued="true"/>

    <!-- This can be enabled, in case the client does not know what fields may be searched. It isn't enabled by default
         because it's very expensive to index everything twice. -->
    <!-- <copyField source="*" dest="_text_"/> -->

    <!-- Dynamic field definitions allow using convention over configuration
       for fields via the specification of patterns to match field names.
       EXAMPLE:  name="*_i" will match any field ending in _i (like myid_i, z_i)
       RESTRICTION: the glob-like pattern in the name attribute must have a "*" only at the start or the end.  -->
   
    <dynamicField name="*_i"  type="pint"    indexed="true"  stored="true"/>
    <dynamicField name="*_is" type="pints"    indexed="true"  stored="true"/>
    <dynamicField name="*_s"  type="string"  indexed="true"  stored="true" />
    <dynamicField name="*_ss" type="strings"  indexed="true"  stored="true"/>
    <dynamicField name="*_l"  type="plong"   indexed="true"  stored="true"/>
    <dynamicField name="*_ls" type="plongs"   indexed="true"  stored="true"/>
    <dynamicField name="*_t" type="text_general" indexed="true" stored="true" multiValued="false"/>
    <dynamicField name="*_txt" type="text_general" indexed="true" stored="true"/>
    <dynamicField name="*_b"  type="boolean" indexed="true" stored="true"/>
    <dynamicField name="*_bs" type="booleans" indexed="true" stored="true"/>
    <dynamicField name="*_f"  type="pfloat"  indexed="true"  stored="true"/>
    <dynamicField name="*_fs" type="pfloats"  indexed="true"  stored="true"/>
    <dynamicField name="*_d"  type="pdouble" indexed="true"  stored="true"/>
    <dynamicField name="*_ds" type="pdoubles" indexed="true"  stored="true"/>
    <dynamicField name="random_*" type="random"/>
    <dynamicField name="ignored_*" type="ignored"/>

    <!-- Type used for data-driven schema, to add a string copy for each text field -->
    <dynamicField name="*_str" type="strings" stored="false" docValues="true" indexed="false" useDocValuesAsStored="false"/>

    <dynamicField name="*_dt"  type="pdate"    indexed="true"  stored="true"/>
    <dynamicField name="*_dts" type="pdate"    indexed="true"  stored="true" multiValued="true"/>
    <dynamicField name="*_p"  type="location" indexed="true" stored="true"/>
    <dynamicField name="*_srpt"  type="location_rpt" indexed="true" stored="true"/>

    <!-- payloaded dynamic fields -->
    <dynamicField name="*_dpf" type="delimited_payloads_float" indexed="true"  stored="true"/>
    <dynamicField name="*_dpi" type="delimited_payloads_int" indexed="true"  stored="true"/>
    <dynamicField name="*_dps" type="delimited_payloads_string" indexed="true"  stored="true"/>

    <dynamicField name="attr_*" type="text_general" indexed="true" stored="true" multiValued="true"/>

    <!-- Field to use to determine and enforce document uniqueness.
      Unless this field is marked with required="false", it will be a required field
    -->
    <uniqueKey>id</uniqueKey>

    <!-- copyField commands copy one field to another at the time a document
       is added to the index.  It's used either to index the same field differently,
       or to add multiple fields to the same field for easier/faster searching.

    <copyField source="sourceFieldName" dest="destinationFieldName"/>
    -->

    <!-- field type definitions. The "name" attribute is
       just a label to be used by field definitions.  The "class"
       attribute and any other attributes determine the real
       behavior of the fieldType.
         Class names starting with "solr" refer to java classes in a
       standard package such as org.apache.solr.analysis
    -->

    <!-- sortMissingLast and sortMissingFirst attributes are optional attributes are
         currently supported on types that are sorted internally as strings
         and on numeric types.
       This includes "string", "boolean", "pint", "pfloat", "plong", "pdate", "pdouble".
       - If sortMissingLast="true", then a sort on this field will cause documents
         without the field to come after documents with the field,
         regardless of the requested sort order (asc or desc).
       - If sortMissingFirst="true", then a sort on this field will cause documents
         without the field to come before documents with the field,
         regardless of the requested sort order.
       - If sortMissingLast="false" and sortMissingFirst="false" (the default),
         then default lucene sorting will be used which places docs without the
         field first in an ascending sort and last in a descending sort.
    -->

    <!-- The StrField type is not analyzed, but indexed/stored verbatim. -->
    <fieldType name="string" class="solr.StrField" sortMissingLast="true" docValues="true" />
    <fieldType name="strings" class="solr.StrField" sortMissingLast="true" multiValued="true" docValues="true" />

    <!-- boolean type: "true" or "false" -->
    <fieldType name="boolean" class="solr.BoolField" sortMissingLast="true"/>
    <fieldType name="booleans" class="solr.BoolField" sortMissingLast="true" multiValued="true"/>

    <!--
      Numeric field types that index values using KD-trees.
      Point fields don't support FieldCache, so they must have docValues="true" if needed for sorting, faceting, functions, etc.
    -->
    <fieldType name="pint" class="solr.IntPointField" docValues="true"/>
    <fieldType name="pfloat" class="solr.FloatPointField" docValues="true"/>
    <fieldType name="plong" class="solr.LongPointField" docValues="true"/>
    <fieldType name="pdouble" class="solr.DoublePointField" docValues="true"/>

    <fieldType name="pints" class="solr.IntPointField" docValues="true" multiValued="true"/>
    <fieldType name="pfloats" class="solr.FloatPointField" docValues="true" multiValued="true"/>
    <fieldType name="plongs" class="solr.LongPointField" docValues="true" multiValued="true"/>
    <fieldType name="pdoubles" class="solr.DoublePointField" docValues="true" multiValued="true"/>
    <fieldType name="random" class="solr.RandomSortField" indexed="true"/>

    <!-- since fields of this type are by default not stored or indexed,
       any data added to them will be ignored outright.  -->
    <fieldType name="ignored" stored="false" indexed="false" multiValued="true" class="solr.StrField" />

    <!-- The format for this date field is of the form 1995-12-31T23:59:59Z, and
         is a more restricted form of the canonical representation of dateTime
         http://www.w3.org/TR/xmlschema-2/#dateTime    
         The trailing "Z" designates UTC time and is mandatory.
         Optional fractional seconds are allowed: 1995-12-31T23:59:59.999Z
         All other components are mandatory.

         Expressions can also be used to denote calculations that should be
         performed relative to "NOW" to determine the value, ie...

               NOW/HOUR
                  ... Round to the start of the current hour
               NOW-1DAY
                  ... Exactly 1 day prior to now
               NOW/DAY+6MONTHS+3DAYS
                  ... 6 months and 3 days in the future from the start of
                      the current day
                      
      -->
    <!-- KD-tree versions of date fields -->
    <fieldType name="pdate" class="solr.DatePointField" docValues="true"/>
    <fieldType name="pdates" class="solr.DatePointField" docValues="true" multiValued="true"/>
    
    <!--Binary data type. The data should be sent/retrieved in as Base64 encoded Strings -->
    <fieldType name="binary" class="solr.BinaryField"/>
    
    <!-- 
    RankFields can be used to store scoring factors to improve document ranking. They should be used
    in combination with RankQParserPlugin.
    (experimental)
    --> 
    <fieldType name="rank" class="solr.RankField"/>

    <!-- solr.TextField allows the specification of custom text analyzers
         specified as a tokenizer and a list of token filters. Different
         analyzers may be specified for indexing and querying.

         The optional positionIncrementGap puts space between multiple fields of
         this type on the same document, with the purpose of preventing false phrase
         matching across fields.

         For more info on customizing your analyzer chain, please see
         http://lucene.apache.org/solr/guide/understanding-analyzers-tokenizers-and-filters.html#understanding-analyzers-tokenizers-and-filters
     -->

    <!-- One can also specify an existing Analyzer class that has a
         default constructor via the class attribute on the analyzer element.
         Example:
    <fieldType name="text_greek" class="solr.TextField">
      <analyzer class="org.apache.lucene.analysis.el.GreekAnalyzer"/>
    </fieldType>
    -->

    <!-- A text field that only splits on whitespace for exact matching of words -->
    <dynamicField name="*_ws" type="text_ws"  indexed="true"  stored="true"/>
    <fieldType name="text_ws" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
      </analyzer>
    </fieldType>

    <!-- A general text field that has reasonable, generic
         cross-language defaults: it tokenizes with StandardTokenizer,
	       removes stop words from case-insensitive "stopwords.txt"
	       (empty by default), and down cases.  At query time only, it
	       also applies synonyms.
	  -->
    <fieldType name="text_general" class="solr.TextField" positionIncrementGap="100" multiValued="true">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.FlattenGraphFilterFactory"/>
        -->
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>

    
    <!-- SortableTextField generaly functions exactly like TextField,
         except that it supports, and by default uses, docValues for sorting (or faceting)
         on the first 1024 characters of the original field values (which is configurable).
         
         This makes it a bit more useful then TextField in many situations, but the trade-off
         is that it takes up more space on disk; which is why it's not used in place of TextField
         for every fieldType in this _default schema.
	  -->
    <dynamicField name="*_t_sort" type="text_gen_sort" indexed="true" stored="true" multiValued="false"/>
    <dynamicField name="*_txt_sort" type="text_gen_sort" indexed="true" stored="true"/>
    <fieldType name="text_gen_sort" class="solr.SortableTextField" positionIncrementGap="100" multiValued="true">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- A text field with defaults appropriate for English: it tokenizes with StandardTokenizer,
         removes English stop words (lang/stopwords_en.txt), down cases, protects words from protwords.txt, and
         finally applies Porter's stemming.  The query time analyzer also applies synonyms from synonyms.txt. -->
    <dynamicField name="*_txt_en" type="text_en"  indexed="true"  stored="true"/>
    <fieldType name="text_en" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.FlattenGraphFilterFactory"/>
        -->
        <!-- Case insensitive stop word removal.
        -->
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
            />
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.EnglishPossessiveFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <!-- Optionally you may want to use this less aggressive stemmer instead of PorterStemFilterFactory:
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
	      -->
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
        />
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.EnglishPossessiveFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <!-- Optionally you may want to use this less aggressive stemmer instead of PorterStemFilterFactory:
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
	      -->
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- A text field with defaults appropriate for English, plus
         aggressive word-splitting and autophrase features enabled.
         This field is just like text_en, except it adds
         WordDelimiterGraphFilter to enable splitting and matching of
         words on case-change, alpha numeric boundaries, and
         non-alphanumeric chars.  This means certain compound word
         cases will work, for example query "wi fi" will match
         document "WiFi" or "wi-fi".
    -->
    <dynamicField name="*_txt_en_split" type="text_en_splitting"  indexed="true"  stored="true"/>
    <fieldType name="text_en_splitting" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="true">
      <analyzer type="index">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <!-- in this example, we will only use synonyms at query time
        <filter class="solr.SynonymGraphFilterFactory" synonyms="index_synonyms.txt" ignoreCase="true" expand="false"/>
        -->
        <!-- Case insensitive stop word removal.
        -->
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
        />
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="1" catenateNumbers="1" catenateAll="0" splitOnCaseChange="1"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.PorterStemFilterFactory"/>
        <filter class="solr.FlattenGraphFilterFactory" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.StopFilterFactory"
                ignoreCase="true"
                words="lang/stopwords_en.txt"
        />
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="0" catenateNumbers="0" catenateAll="0" splitOnCaseChange="1"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.PorterStemFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Less flexible matching, but less false matches.  Probably not ideal for product names,
         but may be good for SKUs.  Can insert dashes in the wrong place and still match. -->
    <dynamicField name="*_txt_en_split_tight" type="text_en_splitting_tight"  indexed="true"  stored="true"/>
    <fieldType name="text_en_splitting_tight" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="true">
      <analyzer type="index">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_en.txt"/>
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="0" generateNumberParts="0" catenateWords="1" catenateNumbers="1" catenateAll="0"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
        <!-- this filter can remove any duplicate tokens that appear at the same position - sometimes
             possible with WordDelimiterGraphFilter in conjuncton with stemming. -->
        <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
        <filter class="solr.FlattenGraphFilterFactory" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="false"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_en.txt"/>
        <filter class="solr.WordDelimiterGraphFilterFactory" generateWordParts="0" generateNumberParts="0" catenateWords="1" catenateNumbers="1" catenateAll="0"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
        <filter class="solr.EnglishMinimalStemFilterFactory"/>
        <!-- this filter can remove any duplicate tokens that appear at the same position - sometimes
             possible with WordDelimiterGraphFilter in conjuncton with stemming. -->
        <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Just like text_general except it reverses the characters of
	       each token, to enable more efficient leading wildcard queries.
    -->
    <dynamicField name="*_txt_rev" type="text_general_rev"  indexed="true"  stored="true"/>
    <fieldType name="text_general_rev" class="solr.TextField" positionIncrementGap="100">
      <analyzer type="index">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.ReversedWildcardFilterFactory" withOriginal="true"
                maxPosAsterisk="3" maxPosQuestion="2" maxFractionAsterisk="0.33"/>
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.SynonymGraphFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt" />
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>

    <dynamicField name="*_phon_en" type="phonetic_en"  indexed="true"  stored="true"/>
    <fieldType name="phonetic_en" stored="false" indexed="true" class="solr.TextField" >
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.DoubleMetaphoneFilterFactory" inject="false"/>
      </analyzer>
    </fieldType>

    <!-- lowercases the entire field value, keeping it as a single token.  -->
    <dynamicField name="*_s_lower" type="lowercase"  indexed="true"  stored="true"/>
    <fieldType name="lowercase" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.KeywordTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory" />
      </analyzer>
    </fieldType>

    <!-- 
      Example of using PathHierarchyTokenizerFactory at index time, so
      queries for paths match documents at that path, or in descendent paths
    -->
    <dynamicField name="*_descendent_path" type="descendent_path"  indexed="true"  stored="true"/>
    <fieldType name="descendent_path" class="solr.TextField">
      <analyzer type="index">
        <tokenizer class="solr.PathHierarchyTokenizerFactory" delimiter="/" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.KeywordTokenizerFactory" />
      </analyzer>
    </fieldType>

    <!--
      Example of using PathHierarchyTokenizerFactory at query time, so
      queries for paths match documents at that path, or in ancestor paths
    -->
    <dynamicField name="*_ancestor_path" type="ancestor_path"  indexed="true"  stored="true"/>
    <fieldType name="ancestor_path" class="solr.TextField">
      <analyzer type="index">
        <tokenizer class="solr.KeywordTokenizerFactory" />
      </analyzer>
      <analyzer type="query">
        <tokenizer class="solr.PathHierarchyTokenizerFactory" delimiter="/" />
      </analyzer>
    </fieldType>

    <!-- This point type indexes the coordinates as separate fields (subFields)
      If subFieldType is defined, it references a type, and a dynamic field
      definition is created matching *___<typename>.  Alternately, if 
      subFieldSuffix is defined, that is used to create the subFields.
      Example: if subFieldType="double", then the coordinates would be
        indexed in fields myloc_0___double,myloc_1___double.
      Example: if subFieldSuffix="_d" then the coordinates would be indexed
        in fields myloc_0_d,myloc_1_d
      The subFields are an implementation detail of the fieldType, and end
      users normally should not need to know about them.
     -->
    <dynamicField name="*_point" type="point"  indexed="true"  stored="true"/>
    <fieldType name="point" class="solr.PointType" dimension="2" subFieldSuffix="_d"/>

    <!-- A specialized field for geospatial search filters and distance sorting. -->
    <fieldType name="location" class="solr.LatLonPointSpatialField" docValues="true"/>

    <!-- A geospatial field type that supports multiValued and polygon shapes.
      For more information about this and other spatial fields see:
      http://lucene.apache.org/solr/guide/spatial-search.html
    -->
    <fieldType name="location_rpt" class="solr.SpatialRecursivePrefixTreeFieldType"
               geo="true" distErrPct="0.025" maxDistErr="0.001" distanceUnits="kilometers" />

    <!-- Payloaded field types -->
    <fieldType name="delimited_payloads_float" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="float"/>
      </analyzer>
    </fieldType>
    <fieldType name="delimited_payloads_int" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="integer"/>
      </analyzer>
    </fieldType>
    <fieldType name="delimited_payloads_string" stored="false" indexed="true" class="solr.TextField">
      <analyzer>
        <tokenizer class="solr.WhitespaceTokenizerFactory"/>
        <filter class="solr.DelimitedPayloadTokenFilterFactory" encoder="identity"/>
      </analyzer>
    </fieldType>

    <!-- some examples for different languages (generally ordered by ISO code) -->

    <!-- Arabic -->
    <dynamicField name="*_txt_ar" type="text_ar"  indexed="true"  stored="true"/>
    <fieldType name="text_ar" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- for any non-arabic -->
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ar.txt" />
        <!-- normalizes ﻯ to ﻱ, etc -->
        <filter class="solr.ArabicNormalizationFilterFactory"/>
        <filter class="solr.ArabicStemFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Bulgarian -->
    <dynamicField name="*_txt_bg" type="text_bg"  indexed="true"  stored="true"/>
    <fieldType name="text_bg" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/> 
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_bg.txt" /> 
        <filter class="solr.BulgarianStemFilterFactory"/>       
      </analyzer>
    </fieldType>
    
    <!-- Catalan -->
    <dynamicField name="*_txt_ca" type="text_ca"  indexed="true"  stored="true"/>
    <fieldType name="text_ca" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_ca.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ca.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Catalan"/>       
      </analyzer>
    </fieldType>
    
    <!-- CJK bigram (see text_ja for a Japanese configuration using morphological analysis) -->
    <dynamicField name="*_txt_cjk" type="text_cjk"  indexed="true"  stored="true"/>
    <fieldType name="text_cjk" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- normalize width before bigram, as e.g. half-width dakuten combine  -->
        <filter class="solr.CJKWidthFilterFactory"/>
        <!-- for any non-CJK -->
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.CJKBigramFilterFactory"/>
      </analyzer>
    </fieldType>

    <!-- Czech -->
    <dynamicField name="*_txt_cz" type="text_cz"  indexed="true"  stored="true"/>
    <fieldType name="text_cz" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_cz.txt" />
        <filter class="solr.CzechStemFilterFactory"/>       
      </analyzer>
    </fieldType>
    
    <!-- Danish -->
    <dynamicField name="*_txt_da" type="text_da"  indexed="true"  stored="true"/>
    <fieldType name="text_da" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_da.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Danish"/>       
      </analyzer>
    </fieldType>
    
    <!-- German -->
    <dynamicField name="*_txt_de" type="text_de"  indexed="true"  stored="true"/>
    <fieldType name="text_de" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_de.txt" format="snowball" />
        <filter class="solr.GermanNormalizationFilterFactory"/>
        <filter class="solr.GermanLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.GermanMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="German2"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Greek -->
    <dynamicField name="*_txt_el" type="text_el"  indexed="true"  stored="true"/>
    <fieldType name="text_el" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- greek specific lowercase for sigma -->
        <filter class="solr.GreekLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="false" words="lang/stopwords_el.txt" />
        <filter class="solr.GreekStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Spanish -->
    <dynamicField name="*_txt_es" type="text_es"  indexed="true"  stored="true"/>
    <fieldType name="text_es" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_es.txt" format="snowball" />
        <filter class="solr.SpanishLightStemFilterFactory"/>
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Spanish"/> -->
      </analyzer>
    </fieldType>

    <!-- Estonian -->
    <dynamicField name="*_txt_et" type="text_et"  indexed="true"  stored="true"/>
    <fieldType name="text_et" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_et.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Estonian"/>
      </analyzer>
    </fieldType>

    <!-- Basque -->
    <dynamicField name="*_txt_eu" type="text_eu"  indexed="true"  stored="true"/>
    <fieldType name="text_eu" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_eu.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Basque"/>
      </analyzer>
    </fieldType>
    
    <!-- Persian -->
    <dynamicField name="*_txt_fa" type="text_fa"  indexed="true"  stored="true"/>
    <fieldType name="text_fa" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <!-- for ZWNJ -->
        <charFilter class="solr.PersianCharFilterFactory"/>
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.ArabicNormalizationFilterFactory"/>
        <filter class="solr.PersianNormalizationFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fa.txt" />
      </analyzer>
    </fieldType>
    
    <!-- Finnish -->
    <dynamicField name="*_txt_fi" type="text_fi"  indexed="true"  stored="true"/>
    <fieldType name="text_fi" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fi.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Finnish"/>
        <!-- less aggressive: <filter class="solr.FinnishLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- French -->
    <dynamicField name="*_txt_fr" type="text_fr"  indexed="true"  stored="true"/>
    <fieldType name="text_fr" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_fr.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_fr.txt" format="snowball" />
        <filter class="solr.FrenchLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.FrenchMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="French"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Irish -->
    <dynamicField name="*_txt_ga" type="text_ga"  indexed="true"  stored="true"/>
    <fieldType name="text_ga" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes d', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_ga.txt"/>
        <!-- removes n-, etc. position increments is intentionally false! -->
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/hyphenations_ga.txt"/>
        <filter class="solr.IrishLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ga.txt"/>
        <filter class="solr.SnowballPorterFilterFactory" language="Irish"/>
      </analyzer>
    </fieldType>
    
    <!-- Galician -->
    <dynamicField name="*_txt_gl" type="text_gl"  indexed="true"  stored="true"/>
    <fieldType name="text_gl" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_gl.txt" />
        <filter class="solr.GalicianStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.GalicianMinimalStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Hindi -->
    <dynamicField name="*_txt_hi" type="text_hi"  indexed="true"  stored="true"/>
    <fieldType name="text_hi" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <!-- normalizes unicode representation -->
        <filter class="solr.IndicNormalizationFilterFactory"/>
        <!-- normalizes variation in spelling -->
        <filter class="solr.HindiNormalizationFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hi.txt" />
        <filter class="solr.HindiStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Hungarian -->
    <dynamicField name="*_txt_hu" type="text_hu"  indexed="true"  stored="true"/>
    <fieldType name="text_hu" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hu.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Hungarian"/>
        <!-- less aggressive: <filter class="solr.HungarianLightStemFilterFactory"/> -->   
      </analyzer>
    </fieldType>
    
    <!-- Armenian -->
    <dynamicField name="*_txt_hy" type="text_hy"  indexed="true"  stored="true"/>
    <fieldType name="text_hy" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_hy.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Armenian"/>
      </analyzer>
    </fieldType>
    
    <!-- Indonesian -->
    <dynamicField name="*_txt_id" type="text_id"  indexed="true"  stored="true"/>
    <fieldType name="text_id" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_id.txt" />
        <!-- for a less aggressive approach (only inflectional suffixes), set stemDerivational to false -->
        <filter class="solr.IndonesianStemFilterFactory" stemDerivational="true"/>
      </analyzer>
    </fieldType>
    
    <!-- Italian -->
  <dynamicField name="*_txt_it" type="text_it"  indexed="true"  stored="true"/>
  <fieldType name="text_it" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <!-- removes l', etc -->
        <filter class="solr.ElisionFilterFactory" ignoreCase="true" articles="lang/contractions_it.txt"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_it.txt" format="snowball" />
        <filter class="solr.ItalianLightStemFilterFactory"/>
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Italian"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Japanese using morphological analysis (see text_cjk for a configuration using bigramming)

         NOTE: If you want to optimize search for precision, use default operator AND in your request
         handler config (q.op) Use OR if you would like to optimize for recall (default).
    -->
    <dynamicField name="*_txt_ja" type="text_ja"  indexed="true"  stored="true"/>
    <fieldType name="text_ja" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="false">
      <analyzer>
        <!-- Kuromoji Japanese morphological analyzer/tokenizer (JapaneseTokenizer)

           Kuromoji has a search mode (default) that does segmentation useful for search.  A heuristic
           is used to segment compounds into its parts and the compound itself is kept as synonym.

           Valid values for attribute mode are:
              normal: regular segmentation
              search: segmentation useful for search with synonyms compounds (default)
            extended: same as search mode, but unigrams unknown words (experimental)

           For some applications it might be good to use search mode for indexing and normal mode for
           queries to reduce recall and prevent parts of compounds from being matched and highlighted.
           Use <analyzer type="index"> and <analyzer type="query"> for this and mode normal in query.

           Kuromoji also has a convenient user dictionary feature that allows overriding the statistical
           model with your own entries for segmentation, part-of-speech tags and readings without a need
           to specify weights.  Notice that user dictionaries have not been subject to extensive testing.

           User dictionary attributes are:
                     userDictionary: user dictionary filename
             userDictionaryEncoding: user dictionary encoding (default is UTF-8)

           See lang/userdict_ja.txt for a sample user dictionary file.

           Punctuation characters are discarded by default.  Use discardPunctuation="false" to keep them.
        -->
        <tokenizer class="solr.JapaneseTokenizerFactory" mode="search"/>
        <!--<tokenizer class="solr.JapaneseTokenizerFactory" mode="search" userDictionary="lang/userdict_ja.txt"/>-->
        <!-- Reduces inflected verbs and adjectives to their base/dictionary forms (辞書形) -->
        <filter class="solr.JapaneseBaseFormFilterFactory"/>
        <!-- Removes tokens with certain part-of-speech tags -->
        <filter class="solr.JapanesePartOfSpeechStopFilterFactory" tags="lang/stoptags_ja.txt" />
        <!-- Normalizes full-width romaji to half-width and half-width kana to full-width (Unicode NFKC subset) -->
        <filter class="solr.CJKWidthFilterFactory"/>
        <!-- Removes common tokens typically not useful for search, but have a negative effect on ranking -->
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ja.txt" />
        <!-- Normalizes common katakana spelling variations by removing any last long sound character (U+30FC) -->
        <filter class="solr.JapaneseKatakanaStemFilterFactory" minimumLength="4"/>
        <!-- Lower-cases romaji characters -->
        <filter class="solr.LowerCaseFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Korean morphological analysis -->
    <dynamicField name="*_txt_ko" type="text_ko"  indexed="true"  stored="true"/>
    <fieldType name="text_ko" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <!-- Nori Korean morphological analyzer/tokenizer (KoreanTokenizer)
          The Korean (nori) analyzer integrates Lucene nori analysis module into Solr.
          It uses the mecab-ko-dic dictionary to perform morphological analysis of Korean texts.

          This dictionary was built with MeCab, it defines a format for the features adapted
          for the Korean language.
          
          Nori also has a convenient user dictionary feature that allows overriding the statistical
          model with your own entries for segmentation, part-of-speech tags and readings without a need
          to specify weights. Notice that user dictionaries have not been subject to extensive testing.

          The tokenizer supports multiple schema attributes:
            * userDictionary: User dictionary path.
            * userDictionaryEncoding: User dictionary encoding.
            * decompoundMode: Decompound mode. Either 'none', 'discard', 'mixed'. Default is 'discard'.
            * outputUnknownUnigrams: If true outputs unigrams for unknown words.
        -->
        <tokenizer class="solr.KoreanTokenizerFactory" decompoundMode="discard" outputUnknownUnigrams="false"/>
        <!-- Removes some part of speech stuff like EOMI (Pos.E), you can add a parameter 'tags',
          listing the tags to remove. By default it removes: 
          E, IC, J, MAG, MAJ, MM, SP, SSC, SSO, SC, SE, XPN, XSA, XSN, XSV, UNA, NA, VSV
          This is basically an equivalent to stemming.
        -->
        <filter class="solr.KoreanPartOfSpeechStopFilterFactory" />
        <!-- Replaces term text with the Hangul transcription of Hanja characters, if applicable: -->
        <filter class="solr.KoreanReadingFormFilterFactory" />
        <filter class="solr.LowerCaseFilterFactory" />
      </analyzer>
    </fieldType>

    <!-- Latvian -->
    <dynamicField name="*_txt_lv" type="text_lv"  indexed="true"  stored="true"/>
    <fieldType name="text_lv" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_lv.txt" />
        <filter class="solr.LatvianStemFilterFactory"/>
      </analyzer>
    </fieldType>
    
    <!-- Dutch -->
    <dynamicField name="*_txt_nl" type="text_nl"  indexed="true"  stored="true"/>
    <fieldType name="text_nl" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_nl.txt" format="snowball" />
        <filter class="solr.StemmerOverrideFilterFactory" dictionary="lang/stemdict_nl.txt" ignoreCase="false"/>
        <filter class="solr.SnowballPorterFilterFactory" language="Dutch"/>
      </analyzer>
    </fieldType>
    
    <!-- Norwegian -->
    <dynamicField name="*_txt_no" type="text_no"  indexed="true"  stored="true"/>
    <fieldType name="text_no" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_no.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Norwegian"/>
        <!-- less aggressive: <filter class="solr.NorwegianLightStemFilterFactory"/> -->
        <!-- singular/plural: <filter class="solr.NorwegianMinimalStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Portuguese -->
  <dynamicField name="*_txt_pt" type="text_pt"  indexed="true"  stored="true"/>
  <fieldType name="text_pt" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_pt.txt" format="snowball" />
        <filter class="solr.PortugueseLightStemFilterFactory"/>
        <!-- less aggressive: <filter class="solr.PortugueseMinimalStemFilterFactory"/> -->
        <!-- more aggressive: <filter class="solr.SnowballPorterFilterFactory" language="Portuguese"/> -->
        <!-- most aggressive: <filter class="solr.PortugueseStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Romanian -->
    <dynamicField name="*_txt_ro" type="text_ro"  indexed="true"  stored="true"/>
    <fieldType name="text_ro" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ro.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Romanian"/>
      </analyzer>
    </fieldType>
    
    <!-- Russian -->
    <dynamicField name="*_txt_ru" type="text_ru"  indexed="true"  stored="true"/>
    <fieldType name="text_ru" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_ru.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Russian"/>
        <!-- less aggressive: <filter class="solr.RussianLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Swedish -->
    <dynamicField name="*_txt_sv" type="text_sv"  indexed="true"  stored="true"/>
    <fieldType name="text_sv" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_sv.txt" format="snowball" />
        <filter class="solr.SnowballPorterFilterFactory" language="Swedish"/>
        <!-- less aggressive: <filter class="solr.SwedishLightStemFilterFactory"/> -->
      </analyzer>
    </fieldType>
    
    <!-- Thai -->
    <dynamicField name="*_txt_th" type="text_th"  indexed="true"  stored="true"/>
    <fieldType name="text_th" class="solr.TextField" positionIncrementGap="100">
      <analyzer>
        <tokenizer class="solr.ThaiTokenizerFactory"/>
        <filter class="solr.LowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="true" words="lang/stopwords_th.txt" />
      </analyzer>
    </fieldType>
    
    <!-- Turkish -->
    <dynamicField name="*_txt_tr" type="text_tr"  indexed="true"  stored="true"/>
    <fieldType name="text_tr" class="solr.TextField" positionIncrementGap="100">
      <analyzer> 
        <tokenizer class="solr.StandardTokenizerFactory"/>
        <filter class="solr.TurkishLowerCaseFilterFactory"/>
        <filter class="solr.StopFilterFactory" ignoreCase="false" words="lang/stopwords_tr.txt" />
        <filter class="solr.SnowballPorterFilterFactory" language="Turkish"/>
      </analyzer>
    </fieldType>

    <!-- Similarity is the scoring routine for each document vs. a query.
       A custom Similarity or SimilarityFactory may be specified here, but 
       the default is fine for most applications.  
       For more info: http://lucene.apache.org/solr/guide/other-schema-elements.html#OtherSchemaElements-Similarity
    -->
    <!--
     <similarity class="com.example.solr.CustomSimilarityFactory">
       <str name="paramkey">param value</str>
     </similarity>
    -->

</schema>
                       xMPF�  xMPF�                              /configs/_default/protwords.txt  i# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#-----------------------------------------------------------------------
# Use a protected word file to protect against the stemmer reducing two
# unrelated words to the same base word.

# Some non-words that normally won't be encountered,
# just to test that they won't be stemmed.
dontstems
zwhacky

              �       �  xMPHr  xMPHr                           �    /configs/_default/solrconfig.xml  ��<?xml version="1.0" encoding="UTF-8" ?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

<!--
     For more details about configurations options that may appear in
     this file, see http://wiki.apache.org/solr/SolrConfigXml.
-->
<config>
  <!-- In all configuration below, a prefix of "solr." for class names
       is an alias that causes solr to search appropriate packages,
       including org.apache.solr.(search|update|request|core|analysis)

       You may also specify a fully qualified Java classname if you
       have your own custom plugins.
    -->

  <!-- Controls what version of Lucene various components of Solr
       adhere to.  Generally, you want to use the latest version to
       get all bug fixes and improvements. It is highly recommended
       that you fully re-index after changing this setting as it can
       affect both how text is indexed and queried.
  -->
  <luceneMatchVersion>8.8.1</luceneMatchVersion>

  <!-- <lib/> directives can be used to instruct Solr to load any Jars
       identified and use them to resolve any "plugins" specified in
       your solrconfig.xml or schema.xml (ie: Analyzers, Request
       Handlers, etc...).

       All directories and paths are resolved relative to the
       instanceDir.

       Please note that <lib/> directives are processed in the order
       that they appear in your solrconfig.xml file, and are "stacked"
       on top of each other when building a ClassLoader - so if you have
       plugin jars with dependencies on other jars, the "lower level"
       dependency jars should be loaded first.

       If a "./lib" directory exists in your instanceDir, all files
       found in it are included as if you had used the following
       syntax...

              <lib dir="./lib" />
    -->

  <!-- A 'dir' option by itself adds any files found in the directory
       to the classpath, this is useful for including all jars in a
       directory.

       When a 'regex' is specified in addition to a 'dir', only the
       files in that directory which completely match the regex
       (anchored on both ends) will be included.

       If a 'dir' option (with or without a regex) is used and nothing
       is found that matches, a warning will be logged.

       The example below can be used to load a solr-contrib along
       with their external dependencies.
    -->
    <!-- <lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-ltr-\d.*\.jar" /> -->

  <!-- an exact 'path' can be used instead of a 'dir' to specify a
       specific jar file.  This will cause a serious error to be logged
       if it can't be loaded.
    -->
  <!--
     <lib path="../a-jar-that-does-not-exist.jar" />
  -->

  <!-- Data Directory

       Used to specify an alternate directory to hold all index data
       other than the default ./data under the Solr home.  If
       replication is in use, this should match the replication
       configuration.
    -->
  <dataDir>${solr.data.dir:}</dataDir>


  <!-- The DirectoryFactory to use for indexes.

       solr.StandardDirectoryFactory is filesystem
       based and tries to pick the best implementation for the current
       JVM and platform.  solr.NRTCachingDirectoryFactory, the default,
       wraps solr.StandardDirectoryFactory and caches small files in memory
       for better NRT performance.

       One can force a particular implementation via solr.MMapDirectoryFactory,
       solr.NIOFSDirectoryFactory, or solr.SimpleFSDirectoryFactory.

       solr.RAMDirectoryFactory is memory based and not persistent.
    -->
  <directoryFactory name="DirectoryFactory"
                    class="${solr.directoryFactory:solr.NRTCachingDirectoryFactory}"/>

  <!-- The CodecFactory for defining the format of the inverted index.
       The default implementation is SchemaCodecFactory, which is the official Lucene
       index format, but hooks into the schema to provide per-field customization of
       the postings lists and per-document values in the fieldType element
       (postingsFormat/docValuesFormat). Note that most of the alternative implementations
       are experimental, so if you choose to customize the index format, it's a good
       idea to convert back to the official format e.g. via IndexWriter.addIndexes(IndexReader)
       before upgrading to a newer version to avoid unnecessary reindexing.
       A "compressionMode" string element can be added to <codecFactory> to choose
       between the existing compression modes in the default codec: "BEST_SPEED" (default)
       or "BEST_COMPRESSION".
  -->
  <codecFactory class="solr.SchemaCodecFactory"/>

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       Index Config - These settings control low-level behavior of indexing
       Most example settings here show the default value, but are commented
       out, to more easily see where customizations have been made.

       Note: This replaces <indexDefaults> and <mainIndex> from older versions
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
  <indexConfig>
    <!-- maxFieldLength was removed in 4.0. To get similar behavior, include a
         LimitTokenCountFilterFactory in your fieldType definition. E.g.
     <filter class="solr.LimitTokenCountFilterFactory" maxTokenCount="10000"/>
    -->
    <!-- Maximum time to wait for a write lock (ms) for an IndexWriter. Default: 1000 -->
    <!-- <writeLockTimeout>1000</writeLockTimeout>  -->

    <!-- Expert: Enabling compound file will use less files for the index,
         using fewer file descriptors on the expense of performance decrease.
         Default in Lucene is "true". Default in Solr is "false" (since 3.6) -->
    <!-- <useCompoundFile>false</useCompoundFile> -->

    <!-- ramBufferSizeMB sets the amount of RAM that may be used by Lucene
         indexing for buffering added documents and deletions before they are
         flushed to the Directory.
         maxBufferedDocs sets a limit on the number of documents buffered
         before flushing.
         If both ramBufferSizeMB and maxBufferedDocs is set, then
         Lucene will flush based on whichever limit is hit first.  -->
    <!-- <ramBufferSizeMB>100</ramBufferSizeMB> -->
    <!-- <maxBufferedDocs>1000</maxBufferedDocs> -->

    <!-- Expert: ramPerThreadHardLimitMB sets the maximum amount of RAM that can be consumed
         per thread before they are flushed. When limit is exceeded, this triggers a forced
         flush even if ramBufferSizeMB has not been exceeded.
         This is a safety limit to prevent Lucene's DocumentsWriterPerThread from address space
         exhaustion due to its internal 32 bit signed integer based memory addressing.
         The specified value should be greater than 0 and less than 2048MB. When not specified,
         Solr uses Lucene's default value 1945. -->
    <!-- <ramPerThreadHardLimitMB>1945</ramPerThreadHardLimitMB> -->

    <!-- Expert: Merge Policy
         The Merge Policy in Lucene controls how merging of segments is done.
         The default since Solr/Lucene 3.3 is TieredMergePolicy.
         The default since Lucene 2.3 was the LogByteSizeMergePolicy,
         Even older versions of Lucene used LogDocMergePolicy.
      -->
    <!--
        <mergePolicyFactory class="org.apache.solr.index.TieredMergePolicyFactory">
          <int name="maxMergeAtOnce">10</int>
          <int name="segmentsPerTier">10</int>
          <double name="noCFSRatio">0.1</double>
        </mergePolicyFactory>
      -->

    <!-- Expert: Merge Scheduler
         The Merge Scheduler in Lucene controls how merges are
         performed.  The ConcurrentMergeScheduler (Lucene 2.3 default)
         can perform merges in the background using separate threads.
         The SerialMergeScheduler (Lucene 2.2 default) does not.
     -->
    <!--
       <mergeScheduler class="org.apache.lucene.index.ConcurrentMergeScheduler"/>
       -->

    <!-- LockFactory

         This option specifies which Lucene LockFactory implementation
         to use.

         single = SingleInstanceLockFactory - suggested for a
                  read-only index or when there is no possibility of
                  another process trying to modify the index.
         native = NativeFSLockFactory - uses OS native file locking.
                  Do not use when multiple solr webapps in the same
                  JVM are attempting to share a single index.
         simple = SimpleFSLockFactory  - uses a plain file for locking

         Defaults: 'native' is default for Solr3.6 and later, otherwise
                   'simple' is the default

         More details on the nuances of each LockFactory...
         http://wiki.apache.org/lucene-java/AvailableLockFactories
    -->
    <lockType>${solr.lock.type:native}</lockType>

    <!-- Commit Deletion Policy
         Custom deletion policies can be specified here. The class must
         implement org.apache.lucene.index.IndexDeletionPolicy.

         The default Solr IndexDeletionPolicy implementation supports
         deleting index commit points on number of commits, age of
         commit point and optimized status.

         The latest commit point should always be preserved regardless
         of the criteria.
    -->
    <!--
    <deletionPolicy class="solr.SolrDeletionPolicy">
    -->
    <!-- The number of commit points to be kept -->
    <!-- <str name="maxCommitsToKeep">1</str> -->
    <!-- The number of optimized commit points to be kept -->
    <!-- <str name="maxOptimizedCommitsToKeep">0</str> -->
    <!--
        Delete all commit points once they have reached the given age.
        Supports DateMathParser syntax e.g.
      -->
    <!--
       <str name="maxCommitAge">30MINUTES</str>
       <str name="maxCommitAge">1DAY</str>
    -->
    <!--
    </deletionPolicy>
    -->

    <!-- Lucene Infostream

         To aid in advanced debugging, Lucene provides an "InfoStream"
         of detailed information when indexing.

         Setting The value to true will instruct the underlying Lucene
         IndexWriter to write its debugging info the specified file
      -->
    <!-- <infoStream file="INFOSTREAM.txt">false</infoStream> -->
  </indexConfig>


  <!-- JMX

       This example enables JMX if and only if an existing MBeanServer
       is found, use this if you want to configure JMX through JVM
       parameters. Remove this to disable exposing Solr configuration
       and statistics to JMX.

       For more details see http://wiki.apache.org/solr/SolrJmx
    -->
  <jmx />
  <!-- If you want to connect to a particular server, specify the
       agentId
    -->
  <!-- <jmx agentId="myAgent" /> -->
  <!-- If you want to start a new MBeanServer, specify the serviceUrl -->
  <!-- <jmx serviceUrl="service:jmx:rmi:///jndi/rmi://localhost:9999/solr"/>
    -->

  <!-- The default high-performance update handler -->
  <updateHandler class="solr.DirectUpdateHandler2">

    <!-- Enables a transaction log, used for real-time get, durability, and
         and solr cloud replica recovery.  The log can grow as big as
         uncommitted changes to the index, so use of a hard autoCommit
         is recommended (see below).
         "dir" - the target directory for transaction logs, defaults to the
                solr data directory.
         "numVersionBuckets" - sets the number of buckets used to keep
                track of max version values when checking for re-ordered
                updates; increase this value to reduce the cost of
                synchronizing access to version buckets during high-volume
                indexing, this requires 8 bytes (long) * numVersionBuckets
                of heap space per Solr core.
    -->
    <updateLog>
      <str name="dir">${solr.ulog.dir:}</str>
      <int name="numVersionBuckets">${solr.ulog.numVersionBuckets:65536}</int>
    </updateLog>

    <!-- AutoCommit

         Perform a hard commit automatically under certain conditions.
         Instead of enabling autoCommit, consider using "commitWithin"
         when adding documents.

         http://wiki.apache.org/solr/UpdateXmlMessages

         maxDocs - Maximum number of documents to add since the last
                   commit before automatically triggering a new commit.

         maxTime - Maximum amount of time in ms that is allowed to pass
                   since a document was added before automatically
                   triggering a new commit.
         openSearcher - if false, the commit causes recent index changes
           to be flushed to stable storage, but does not cause a new
           searcher to be opened to make those changes visible.

         If the updateLog is enabled, then it's highly recommended to
         have some sort of hard autoCommit to limit the log size.
      -->
    <autoCommit>
      <maxTime>${solr.autoCommit.maxTime:15000}</maxTime>
      <openSearcher>false</openSearcher>
    </autoCommit>

    <!-- softAutoCommit is like autoCommit except it causes a
         'soft' commit which only ensures that changes are visible
         but does not ensure that data is synced to disk.  This is
         faster and more near-realtime friendly than a hard commit.
      -->

    <autoSoftCommit>
      <maxTime>${solr.autoSoftCommit.maxTime:-1}</maxTime>
    </autoSoftCommit>

    <!-- Update Related Event Listeners

         Various IndexWriter related events can trigger Listeners to
         take actions.

         postCommit - fired after every commit or optimize command
         postOptimize - fired after every optimize command
      -->

  </updateHandler>

  <!-- IndexReaderFactory

       Use the following format to specify a custom IndexReaderFactory,
       which allows for alternate IndexReader implementations.

       ** Experimental Feature **

       Please note - Using a custom IndexReaderFactory may prevent
       certain other features from working. The API to
       IndexReaderFactory may change without warning or may even be
       removed from future releases if the problems cannot be
       resolved.


       ** Features that may not work with custom IndexReaderFactory **

       The ReplicationHandler assumes a disk-resident index. Using a
       custom IndexReader implementation may cause incompatibility
       with ReplicationHandler and may cause replication to not work
       correctly. See SOLR-1366 for details.

    -->
  <!--
  <indexReaderFactory name="IndexReaderFactory" class="package.class">
    <str name="someArg">Some Value</str>
  </indexReaderFactory >
  -->

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       Query section - these settings control query time things like caches
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
  <query>

    <!-- Maximum number of clauses allowed when parsing a boolean query string.
         
         This limit only impacts boolean queries specified by a user as part of a query string,
         and provides per-collection controls on how complex user specified boolean queries can
         be.  Query strings that specify more clauses then this will result in an error.
         
         If this per-collection limit is greater then the global `maxBooleanClauses` limit
         specified in `solr.xml`, it will have no effect, as that setting also limits the size
         of user specified boolean queries.
      -->
    <maxBooleanClauses>${solr.max.booleanClauses:1024}</maxBooleanClauses>

    <!-- Solr Internal Query Caches

         There are four implementations of cache available for Solr:
         LRUCache, based on a synchronized LinkedHashMap, 
         LFUCache and FastLRUCache, based on a ConcurrentHashMap, and CaffeineCache -
         a modern and robust cache implementation. Note that in Solr 9.0
         only CaffeineCache will be available, other implementations are now
         deprecated.

         FastLRUCache has faster gets and slower puts in single
         threaded operation and thus is generally faster than LRUCache
         when the hit ratio of the cache is high (> 75%), and may be
         faster under other scenarios on multi-cpu systems.
         Starting with Solr 9.0 the default cache implementation used is CaffeineCache.
    -->

    <!-- Filter Cache

         Cache used by SolrIndexSearcher for filters (DocSets),
         unordered sets of *all* documents that match a query.  When a
         new searcher is opened, its caches may be prepopulated or
         "autowarmed" using data from caches in the old searcher.
         autowarmCount is the number of items to prepopulate.  For
         LRUCache, the autowarmed items will be the most recently
         accessed items.

         Parameters:
           class - the SolrCache implementation LRUCache or
               (LRUCache or FastLRUCache)
           size - the maximum number of entries in the cache
           initialSize - the initial capacity (number of entries) of
               the cache.  (see java.util.HashMap)
           autowarmCount - the number of entries to prepopulate from
               an old cache.
           maxRamMB - the maximum amount of RAM (in MB) that this cache is allowed
                      to occupy. Note that when this option is specified, the size
                      and initialSize parameters are ignored.
      -->
    <filterCache size="512"
                 initialSize="512"
                 autowarmCount="0"/>

    <!-- Query Result Cache

         Caches results of searches - ordered lists of document ids
         (DocList) based on a query, a sort, and the range of documents requested.
         Additional supported parameter by LRUCache:
            maxRamMB - the maximum amount of RAM (in MB) that this cache is allowed
                       to occupy
      -->
    <queryResultCache size="512"
                      initialSize="512"
                      autowarmCount="0"/>

    <!-- Document Cache

         Caches Lucene Document objects (the stored fields for each
         document).  Since Lucene internal document ids are transient,
         this cache will not be autowarmed.
      -->
    <documentCache size="512"
                   initialSize="512"
                   autowarmCount="0"/>

    <!-- custom cache currently used by block join -->
    <cache name="perSegFilter"
           size="10"
           initialSize="0"
           autowarmCount="10"
           regenerator="solr.NoOpRegenerator" />

    <!-- Field Value Cache

         Cache used to hold field values that are quickly accessible
         by document id.  The fieldValueCache is created by default
         even if not configured here.
      -->
    <!--
       <fieldValueCache size="512"
                        autowarmCount="128"
                        showItems="32" />
      -->

    <!-- Custom Cache

         Example of a generic cache.  These caches may be accessed by
         name through SolrIndexSearcher.getCache(),cacheLookup(), and
         cacheInsert().  The purpose is to enable easy caching of
         user/application level data.  The regenerator argument should
         be specified as an implementation of solr.CacheRegenerator
         if autowarming is desired.
      -->
    <!--
       <cache name="myUserCache"
              size="4096"
              initialSize="1024"
              autowarmCount="1024"
              regenerator="com.mycompany.MyRegenerator"
              />
      -->


    <!-- Lazy Field Loading

         If true, stored fields that are not requested will be loaded
         lazily.  This can result in a significant speed improvement
         if the usual case is to not load all stored fields,
         especially if the skipped fields are large compressed text
         fields.
    -->
    <enableLazyFieldLoading>true</enableLazyFieldLoading>

    <!-- Use Filter For Sorted Query

         A possible optimization that attempts to use a filter to
         satisfy a search.  If the requested sort does not include
         score, then the filterCache will be checked for a filter
         matching the query. If found, the filter will be used as the
         source of document ids, and then the sort will be applied to
         that.

         For most situations, this will not be useful unless you
         frequently get the same search repeatedly with different sort
         options, and none of them ever use "score"
      -->
    <!--
       <useFilterForSortedQuery>true</useFilterForSortedQuery>
      -->

    <!-- Result Window Size

         An optimization for use with the queryResultCache.  When a search
         is requested, a superset of the requested number of document ids
         are collected.  For example, if a search for a particular query
         requests matching documents 10 through 19, and queryWindowSize is 50,
         then documents 0 through 49 will be collected and cached.  Any further
         requests in that range can be satisfied via the cache.
      -->
    <queryResultWindowSize>20</queryResultWindowSize>

    <!-- Maximum number of documents to cache for any entry in the
         queryResultCache.
      -->
    <queryResultMaxDocsCached>200</queryResultMaxDocsCached>

  <!-- Use Filter For Sorted Query

   A possible optimization that attempts to use a filter to
   satisfy a search.  If the requested sort does not include
   score, then the filterCache will be checked for a filter
   matching the query. If found, the filter will be used as the
   source of document ids, and then the sort will be applied to
   that.

   For most situations, this will not be useful unless you
   frequently get the same search repeatedly with different sort
   options, and none of them ever use "score"
-->
    <!--
       <useFilterForSortedQuery>true</useFilterForSortedQuery>
      -->

    <!-- Query Related Event Listeners

         Various IndexSearcher related events can trigger Listeners to
         take actions.

         newSearcher - fired whenever a new searcher is being prepared
         and there is a current searcher handling requests (aka
         registered).  It can be used to prime certain caches to
         prevent long request times for certain requests.

         firstSearcher - fired whenever a new searcher is being
         prepared but there is no current registered searcher to handle
         requests or to gain autowarming data from.


      -->
    <!-- QuerySenderListener takes an array of NamedList and executes a
         local query request for each NamedList in sequence.
      -->
    <listener event="newSearcher" class="solr.QuerySenderListener">
      <arr name="queries">
        <!--
           <lst><str name="q">solr</str><str name="sort">price asc</str></lst>
           <lst><str name="q">rocks</str><str name="sort">weight asc</str></lst>
          -->
      </arr>
    </listener>
    <listener event="firstSearcher" class="solr.QuerySenderListener">
      <arr name="queries">
        <!--
        <lst>
          <str name="q">static firstSearcher warming in solrconfig.xml</str>
        </lst>
        -->
      </arr>
    </listener>

    <!-- Use Cold Searcher

         If a search request comes in and there is no current
         registered searcher, then immediately register the still
         warming searcher and use it.  If "false" then all requests
         will block until the first searcher is done warming.
      -->
    <useColdSearcher>false</useColdSearcher>

  </query>

  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Circuit Breaker Section - This section consists of configurations for
     circuit breakers
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

    <!-- Circuit Breakers

     Circuit breakers are designed to allow stability and predictable query
     execution. They prevent operations that can take down the node and cause
     noisy neighbour issues.

     This flag is the uber control switch which controls the activation/deactivation of all circuit
     breakers. If a circuit breaker wishes to be independently configurable,
     they are free to add their specific configuration but need to ensure that this flag is always
     respected - this should have veto over all independent configuration flags.
    -->
    <circuitBreakers enabled="true">

    <!-- Memory Circuit Breaker Configuration

     Specific configuration for max JVM heap usage circuit breaker. This configuration defines whether
     the circuit breaker is enabled and the threshold percentage of maximum heap allocated beyond which queries will be rejected until the
     current JVM usage goes below the threshold. The valid value range for this value is 50-95.

     Consider a scenario where the max heap allocated is 4 GB and memoryCircuitBreakerThreshold is
     defined as 75. Threshold JVM usage will be 4 * 0.75 = 3 GB. Its generally a good idea to keep this value between 75 - 80% of maximum heap
     allocated.

     If, at any point, the current JVM heap usage goes above 3 GB, queries will be rejected until the heap usage goes below 3 GB again.
     If you see queries getting rejected with 503 error code, check for "Circuit Breakers tripped"
     in logs and the corresponding error message should tell you what transpired (if the failure
     was caused by tripped circuit breakers).

     If, at any point, the current JVM heap usage goes above 3 GB, queries will be rejected until the heap usage goes below 3 GB again.
     If you see queries getting rejected with 503 error code, check for "Circuit Breakers tripped"
     in logs and the corresponding error message should tell you what transpired (if the failure
     was caused by tripped circuit breakers).
    -->
    <!--
   <memBreaker enabled="true" threshold="75"/>
    -->

      <!-- CPU Circuit Breaker Configuration

     Specific configuration for CPU utilization based circuit breaker. This configuration defines whether the circuit breaker is enabled
     and the average load over the last minute at which the circuit breaker should start rejecting queries.

     Consider a scenario where the max heap allocated is 4 GB and memoryCircuitBreakerThreshold is
     defined as 75. Threshold JVM usage will be 4 * 0.75 = 3 GB. Its generally a good idea to keep this value between 75 - 80% of maximum heap
     allocated.
    -->

      <!--
       <cpuBreaker enabled="true" threshold="75"/>
      -->

  </circuitBreakers>


  <!-- Request Dispatcher

       This section contains instructions for how the SolrDispatchFilter
       should behave when processing requests for this SolrCore.

    -->
  <requestDispatcher>
    <!-- Request Parsing

         These settings indicate how Solr Requests may be parsed, and
         what restrictions may be placed on the ContentStreams from
         those requests

         enableRemoteStreaming - enables use of the stream.file
         and stream.url parameters for specifying remote streams.

         multipartUploadLimitInKB - specifies the max size (in KiB) of
         Multipart File Uploads that Solr will allow in a Request.

         formdataUploadLimitInKB - specifies the max size (in KiB) of
         form data (application/x-www-form-urlencoded) sent via
         POST. You can use POST to pass request parameters not
         fitting into the URL.

         addHttpRequestToContext - if set to true, it will instruct
         the requestParsers to include the original HttpServletRequest
         object in the context map of the SolrQueryRequest under the
         key "httpRequest". It will not be used by any of the existing
         Solr components, but may be useful when developing custom
         plugins.

         *** WARNING ***
         Before enabling remote streaming, you should make sure your
         system has authentication enabled.

    <requestParsers enableRemoteStreaming="false"
                    multipartUploadLimitInKB="-1"
                    formdataUploadLimitInKB="-1"
                    addHttpRequestToContext="false"/>
      -->

    <!-- HTTP Caching

         Set HTTP caching related parameters (for proxy caches and clients).

         The options below instruct Solr not to output any HTTP Caching
         related headers
      -->
    <httpCaching never304="true" />
    <!-- If you include a <cacheControl> directive, it will be used to
         generate a Cache-Control header (as well as an Expires header
         if the value contains "max-age=")

         By default, no Cache-Control header is generated.

         You can use the <cacheControl> option even if you have set
         never304="true"
      -->
    <!--
       <httpCaching never304="true" >
         <cacheControl>max-age=30, public</cacheControl>
       </httpCaching>
      -->
    <!-- To enable Solr to respond with automatically generated HTTP
         Caching headers, and to response to Cache Validation requests
         correctly, set the value of never304="false"

         This will cause Solr to generate Last-Modified and ETag
         headers based on the properties of the Index.

         The following options can also be specified to affect the
         values of these headers...

         lastModFrom - the default value is "openTime" which means the
         Last-Modified value (and validation against If-Modified-Since
         requests) will all be relative to when the current Searcher
         was opened.  You can change it to lastModFrom="dirLastMod" if
         you want the value to exactly correspond to when the physical
         index was last modified.

         etagSeed="..." is an option you can change to force the ETag
         header (and validation against If-None-Match requests) to be
         different even if the index has not changed (ie: when making
         significant changes to your config file)

         (lastModifiedFrom and etagSeed are both ignored if you use
         the never304="true" option)
      -->
    <!--
       <httpCaching lastModifiedFrom="openTime"
                    etagSeed="Solr">
         <cacheControl>max-age=30, public</cacheControl>
       </httpCaching>
      -->
  </requestDispatcher>

  <!-- Request Handlers

       http://wiki.apache.org/solr/SolrRequestHandler

       Incoming queries will be dispatched to a specific handler by name
       based on the path specified in the request.

       If a Request Handler is declared with startup="lazy", then it will
       not be initialized until the first request that uses it.

    -->
  <!-- SearchHandler

       http://wiki.apache.org/solr/SearchHandler

       For processing Search Queries, the primary Request Handler
       provided with Solr is "SearchHandler" It delegates to a sequent
       of SearchComponents (see below) and supports distributed
       queries across multiple shards
    -->
  <requestHandler name="/select" class="solr.SearchHandler">
    <!-- default values for query parameters can be specified, these
         will be overridden by parameters in the request
      -->
    <lst name="defaults">
      <str name="echoParams">explicit</str>
      <int name="rows">10</int>
      <!-- Default search field
         <str name="df">text</str> 
        -->
      <!-- Change from JSON to XML format (the default prior to Solr 7.0)
         <str name="wt">xml</str> 
        -->
    </lst>
    <!-- In addition to defaults, "appends" params can be specified
         to identify values which should be appended to the list of
         multi-val params from the query (or the existing "defaults").
      -->
    <!-- In this example, the param "fq=instock:true" would be appended to
         any query time fq params the user may specify, as a mechanism for
         partitioning the index, independent of any user selected filtering
         that may also be desired (perhaps as a result of faceted searching).

         NOTE: there is *absolutely* nothing a client can do to prevent these
         "appends" values from being used, so don't use this mechanism
         unless you are sure you always want it.
      -->
    <!--
       <lst name="appends">
         <str name="fq">inStock:true</str>
       </lst>
      -->
    <!-- "invariants" are a way of letting the Solr maintainer lock down
         the options available to Solr clients.  Any params values
         specified here are used regardless of what values may be specified
         in either the query, the "defaults", or the "appends" params.

         In this example, the facet.field and facet.query params would
         be fixed, limiting the facets clients can use.  Faceting is
         not turned on by default - but if the client does specify
         facet=true in the request, these are the only facets they
         will be able to see counts for; regardless of what other
         facet.field or facet.query params they may specify.

         NOTE: there is *absolutely* nothing a client can do to prevent these
         "invariants" values from being used, so don't use this mechanism
         unless you are sure you always want it.
      -->
    <!--
       <lst name="invariants">
         <str name="facet.field">cat</str>
         <str name="facet.field">manu_exact</str>
         <str name="facet.query">price:[* TO 500]</str>
         <str name="facet.query">price:[500 TO *]</str>
       </lst>
      -->
    <!-- If the default list of SearchComponents is not desired, that
         list can either be overridden completely, or components can be
         prepended or appended to the default list.  (see below)
      -->
    <!--
       <arr name="components">
         <str>nameOfCustomComponent1</str>
         <str>nameOfCustomComponent2</str>
       </arr>
      -->
  </requestHandler>

  <!-- A request handler that returns indented JSON by default -->
  <requestHandler name="/query" class="solr.SearchHandler">
    <lst name="defaults">
      <str name="echoParams">explicit</str>
      <str name="wt">json</str>
      <str name="indent">true</str>
    </lst>
  </requestHandler>

  <initParams path="/update/**,/query,/select,/spell">
    <lst name="defaults">
      <str name="df">_text_</str>
    </lst>
  </initParams>

  <!-- Search Components

       Search components are registered to SolrCore and used by
       instances of SearchHandler (which can access them by name)

       By default, the following components are available:

       <searchComponent name="query"     class="solr.QueryComponent" />
       <searchComponent name="facet"     class="solr.FacetComponent" />
       <searchComponent name="mlt"       class="solr.MoreLikeThisComponent" />
       <searchComponent name="highlight" class="solr.HighlightComponent" />
       <searchComponent name="stats"     class="solr.StatsComponent" />
       <searchComponent name="debug"     class="solr.DebugComponent" />

       Default configuration in a requestHandler would look like:

       <arr name="components">
         <str>query</str>
         <str>facet</str>
         <str>mlt</str>
         <str>highlight</str>
         <str>stats</str>
         <str>debug</str>
       </arr>

       If you register a searchComponent to one of the standard names,
       that will be used instead of the default.

       To insert components before or after the 'standard' components, use:

       <arr name="first-components">
         <str>myFirstComponentName</str>
       </arr>

       <arr name="last-components">
         <str>myLastComponentName</str>
       </arr>

       NOTE: The component registered with the name "debug" will
       always be executed after the "last-components"

     -->

  <!-- Spell Check

       The spell check component can return a list of alternative spelling
       suggestions.

       http://wiki.apache.org/solr/SpellCheckComponent
    -->
  <searchComponent name="spellcheck" class="solr.SpellCheckComponent">

    <str name="queryAnalyzerFieldType">text_general</str>

    <!-- Multiple "Spell Checkers" can be declared and used by this
         component
      -->

    <!-- a spellchecker built from a field of the main index -->
    <lst name="spellchecker">
      <str name="name">default</str>
      <str name="field">_text_</str>
      <str name="classname">solr.DirectSolrSpellChecker</str>
      <!-- the spellcheck distance measure used, the default is the internal levenshtein -->
      <str name="distanceMeasure">internal</str>
      <!-- minimum accuracy needed to be considered a valid spellcheck suggestion -->
      <float name="accuracy">0.5</float>
      <!-- the maximum #edits we consider when enumerating terms: can be 1 or 2 -->
      <int name="maxEdits">2</int>
      <!-- the minimum shared prefix when enumerating terms -->
      <int name="minPrefix">1</int>
      <!-- maximum number of inspections per result. -->
      <int name="maxInspections">5</int>
      <!-- minimum length of a query term to be considered for correction -->
      <int name="minQueryLength">4</int>
      <!-- maximum threshold of documents a query term can appear to be considered for correction -->
      <float name="maxQueryFrequency">0.01</float>
      <!-- uncomment this to require suggestions to occur in 1% of the documents
        <float name="thresholdTokenFrequency">.01</float>
      -->
    </lst>

    <!-- a spellchecker that can break or combine words.  See "/spell" handler below for usage -->
    <!--
    <lst name="spellchecker">
      <str name="name">wordbreak</str>
      <str name="classname">solr.WordBreakSolrSpellChecker</str>
      <str name="field">name</str>
      <str name="combineWords">true</str>
      <str name="breakWords">true</str>
      <int name="maxChanges">10</int>
    </lst>
    -->
  </searchComponent>

  <!-- A request handler for demonstrating the spellcheck component.

       NOTE: This is purely as an example.  The whole purpose of the
       SpellCheckComponent is to hook it into the request handler that
       handles your normal user queries so that a separate request is
       not needed to get suggestions.

       IN OTHER WORDS, THERE IS REALLY GOOD CHANCE THE SETUP BELOW IS
       NOT WHAT YOU WANT FOR YOUR PRODUCTION SYSTEM!

       See http://wiki.apache.org/solr/SpellCheckComponent for details
       on the request parameters.
    -->
  <requestHandler name="/spell" class="solr.SearchHandler" startup="lazy">
    <lst name="defaults">
      <!-- Solr will use suggestions from both the 'default' spellchecker
           and from the 'wordbreak' spellchecker and combine them.
           collations (re-written queries) can include a combination of
           corrections from both spellcheckers -->
      <str name="spellcheck.dictionary">default</str>
      <str name="spellcheck">on</str>
      <str name="spellcheck.extendedResults">true</str>
      <str name="spellcheck.count">10</str>
      <str name="spellcheck.alternativeTermCount">5</str>
      <str name="spellcheck.maxResultsForSuggest">5</str>
      <str name="spellcheck.collate">true</str>
      <str name="spellcheck.collateExtendedResults">true</str>
      <str name="spellcheck.maxCollationTries">10</str>
      <str name="spellcheck.maxCollations">5</str>
    </lst>
    <arr name="last-components">
      <str>spellcheck</str>
    </arr>
  </requestHandler>

  <!-- Terms Component

       http://wiki.apache.org/solr/TermsComponent

       A component to return terms and document frequency of those
       terms
    -->
  <searchComponent name="terms" class="solr.TermsComponent"/>

  <!-- A request handler for demonstrating the terms component -->
  <requestHandler name="/terms" class="solr.SearchHandler" startup="lazy">
    <lst name="defaults">
      <bool name="terms">true</bool>
      <bool name="distrib">false</bool>
    </lst>
    <arr name="components">
      <str>terms</str>
    </arr>
  </requestHandler>

  <!-- Highlighting Component

       http://wiki.apache.org/solr/HighlightingParameters
    -->
  <searchComponent class="solr.HighlightComponent" name="highlight">
    <highlighting>
      <!-- Configure the standard fragmenter -->
      <!-- This could most likely be commented out in the "default" case -->
      <fragmenter name="gap"
                  default="true"
                  class="solr.highlight.GapFragmenter">
        <lst name="defaults">
          <int name="hl.fragsize">100</int>
        </lst>
      </fragmenter>

      <!-- A regular-expression-based fragmenter
           (for sentence extraction)
        -->
      <fragmenter name="regex"
                  class="solr.highlight.RegexFragmenter">
        <lst name="defaults">
          <!-- slightly smaller fragsizes work better because of slop -->
          <int name="hl.fragsize">70</int>
          <!-- allow 50% slop on fragment sizes -->
          <float name="hl.regex.slop">0.5</float>
          <!-- a basic sentence pattern -->
          <str name="hl.regex.pattern">[-\w ,/\n\&quot;&apos;]{20,200}</str>
        </lst>
      </fragmenter>

      <!-- Configure the standard formatter -->
      <formatter name="html"
                 default="true"
                 class="solr.highlight.HtmlFormatter">
        <lst name="defaults">
          <str name="hl.simple.pre"><![CDATA[<em>]]></str>
          <str name="hl.simple.post"><![CDATA[</em>]]></str>
        </lst>
      </formatter>

      <!-- Configure the standard encoder -->
      <encoder name="html"
               class="solr.highlight.HtmlEncoder" />

      <!-- Configure the standard fragListBuilder -->
      <fragListBuilder name="simple"
                       class="solr.highlight.SimpleFragListBuilder"/>

      <!-- Configure the single fragListBuilder -->
      <fragListBuilder name="single"
                       class="solr.highlight.SingleFragListBuilder"/>

      <!-- Configure the weighted fragListBuilder -->
      <fragListBuilder name="weighted"
                       default="true"
                       class="solr.highlight.WeightedFragListBuilder"/>

      <!-- default tag FragmentsBuilder -->
      <fragmentsBuilder name="default"
                        default="true"
                        class="solr.highlight.ScoreOrderFragmentsBuilder">
        <!--
        <lst name="defaults">
          <str name="hl.multiValuedSeparatorChar">/</str>
        </lst>
        -->
      </fragmentsBuilder>

      <!-- multi-colored tag FragmentsBuilder -->
      <fragmentsBuilder name="colored"
                        class="solr.highlight.ScoreOrderFragmentsBuilder">
        <lst name="defaults">
          <str name="hl.tag.pre"><![CDATA[
               <b style="background:yellow">,<b style="background:lawgreen">,
               <b style="background:aquamarine">,<b style="background:magenta">,
               <b style="background:palegreen">,<b style="background:coral">,
               <b style="background:wheat">,<b style="background:khaki">,
               <b style="background:lime">,<b style="background:deepskyblue">]]></str>
          <str name="hl.tag.post"><![CDATA[</b>]]></str>
        </lst>
      </fragmentsBuilder>

      <boundaryScanner name="default"
                       default="true"
                       class="solr.highlight.SimpleBoundaryScanner">
        <lst name="defaults">
          <str name="hl.bs.maxScan">10</str>
          <str name="hl.bs.chars">.,!? &#9;&#10;&#13;</str>
        </lst>
      </boundaryScanner>

      <boundaryScanner name="breakIterator"
                       class="solr.highlight.BreakIteratorBoundaryScanner">
        <lst name="defaults">
          <!-- type should be one of CHARACTER, WORD(default), LINE and SENTENCE -->
          <str name="hl.bs.type">WORD</str>
          <!-- language and country are used when constructing Locale object.  -->
          <!-- And the Locale object will be used when getting instance of BreakIterator -->
          <str name="hl.bs.language">en</str>
          <str name="hl.bs.country">US</str>
        </lst>
      </boundaryScanner>
    </highlighting>
  </searchComponent>

  <!-- Update Processors

       Chains of Update Processor Factories for dealing with Update
       Requests can be declared, and then used by name in Update
       Request Processors

       http://wiki.apache.org/solr/UpdateRequestProcessor

    -->

  <!-- Add unknown fields to the schema

       Field type guessing update processors that will
       attempt to parse string-typed field values as Booleans, Longs,
       Doubles, or Dates, and then add schema fields with the guessed
       field types. Text content will be indexed as "text_general" as
       well as a copy to a plain string version in *_str.

       These require that the schema is both managed and mutable, by
       declaring schemaFactory as ManagedIndexSchemaFactory, with
       mutable specified as true.

       See http://wiki.apache.org/solr/GuessingFieldTypes
    -->
  <updateProcessor class="solr.UUIDUpdateProcessorFactory" name="uuid"/>
  <updateProcessor class="solr.RemoveBlankFieldUpdateProcessorFactory" name="remove-blank"/>
  <updateProcessor class="solr.FieldNameMutatingUpdateProcessorFactory" name="field-name-mutating">
    <str name="pattern">[^\w-\.]</str>
    <str name="replacement">_</str>
  </updateProcessor>
  <updateProcessor class="solr.ParseBooleanFieldUpdateProcessorFactory" name="parse-boolean"/>
  <updateProcessor class="solr.ParseLongFieldUpdateProcessorFactory" name="parse-long"/>
  <updateProcessor class="solr.ParseDoubleFieldUpdateProcessorFactory" name="parse-double"/>
  <updateProcessor class="solr.ParseDateFieldUpdateProcessorFactory" name="parse-date">
    <arr name="format">
      <str>yyyy-MM-dd['T'[HH:mm[:ss[.SSS]][z</str>
      <str>yyyy-MM-dd['T'[HH:mm[:ss[,SSS]][z</str>
      <str>yyyy-MM-dd HH:mm[:ss[.SSS]][z</str>
      <str>yyyy-MM-dd HH:mm[:ss[,SSS]][z</str>
      <str>[EEE, ]dd MMM yyyy HH:mm[:ss] z</str>
      <str>EEEE, dd-MMM-yy HH:mm:ss z</str>
      <str>EEE MMM ppd HH:mm:ss [z ]yyyy</str>
    </arr>
  </updateProcessor>
  <updateProcessor class="solr.AddSchemaFieldsUpdateProcessorFactory" name="add-schema-fields">
    <lst name="typeMapping">
      <str name="valueClass">java.lang.String</str>
      <str name="fieldType">text_general</str>
      <lst name="copyField">
        <str name="dest">*_str</str>
        <int name="maxChars">256</int>
      </lst>
      <!-- Use as default mapping instead of defaultFieldType -->
      <bool name="default">true</bool>
    </lst>
    <lst name="typeMapping">
      <str name="valueClass">java.lang.Boolean</str>
      <str name="fieldType">booleans</str>
    </lst>
    <lst name="typeMapping">
      <str name="valueClass">java.util.Date</str>
      <str name="fieldType">pdates</str>
    </lst>
    <lst name="typeMapping">
      <str name="valueClass">java.lang.Long</str>
      <str name="valueClass">java.lang.Integer</str>
      <str name="fieldType">plongs</str>
    </lst>
    <lst name="typeMapping">
      <str name="valueClass">java.lang.Number</str>
      <str name="fieldType">pdoubles</str>
    </lst>
  </updateProcessor>

  <!-- The update.autoCreateFields property can be turned to false to disable schemaless mode -->
  <updateRequestProcessorChain name="add-unknown-fields-to-the-schema" default="${update.autoCreateFields:true}"
           processor="uuid,remove-blank,field-name-mutating,parse-boolean,parse-long,parse-double,parse-date,add-schema-fields">
    <processor class="solr.LogUpdateProcessorFactory"/>
    <processor class="solr.DistributedUpdateProcessorFactory"/>
    <processor class="solr.RunUpdateProcessorFactory"/>
  </updateRequestProcessorChain>

  <!-- Deduplication

       An example dedup update processor that creates the "id" field
       on the fly based on the hash code of some other fields.  This
       example has overwriteDupes set to false since we are using the
       id field as the signatureField and Solr will maintain
       uniqueness based on that anyway.

    -->
  <!--
     <updateRequestProcessorChain name="dedupe">
       <processor class="solr.processor.SignatureUpdateProcessorFactory">
         <bool name="enabled">true</bool>
         <str name="signatureField">id</str>
         <bool name="overwriteDupes">false</bool>
         <str name="fields">name,features,cat</str>
         <str name="signatureClass">solr.processor.Lookup3Signature</str>
       </processor>
       <processor class="solr.LogUpdateProcessorFactory" />
       <processor class="solr.RunUpdateProcessorFactory" />
     </updateRequestProcessorChain>
    -->

  <!-- Response Writers

       http://wiki.apache.org/solr/QueryResponseWriter

       Request responses will be written using the writer specified by
       the 'wt' request parameter matching the name of a registered
       writer.

       The "default" writer is the default and will be used if 'wt' is
       not specified in the request.
    -->
  <!-- The following response writers are implicitly configured unless
       overridden...
    -->
  <!--
     <queryResponseWriter name="xml"
                          default="true"
                          class="solr.XMLResponseWriter" />
     <queryResponseWriter name="json" class="solr.JSONResponseWriter"/>
     <queryResponseWriter name="python" class="solr.PythonResponseWriter"/>
     <queryResponseWriter name="ruby" class="solr.RubyResponseWriter"/>
     <queryResponseWriter name="php" class="solr.PHPResponseWriter"/>
     <queryResponseWriter name="phps" class="solr.PHPSerializedResponseWriter"/>
     <queryResponseWriter name="csv" class="solr.CSVResponseWriter"/>
     <queryResponseWriter name="schema.xml" class="solr.SchemaXmlResponseWriter"/>
    -->

  <queryResponseWriter name="json" class="solr.JSONResponseWriter">
    <!-- For the purposes of the tutorial, JSON responses are written as
     plain text so that they are easy to read in *any* browser.
     If you expect a MIME type of "application/json" just remove this override.
    -->
    <str name="content-type">text/plain; charset=UTF-8</str>
  </queryResponseWriter>

  <!-- Query Parsers

       https://lucene.apache.org/solr/guide/query-syntax-and-parsing.html

       Multiple QParserPlugins can be registered by name, and then
       used in either the "defType" param for the QueryComponent (used
       by SearchHandler) or in LocalParams
    -->
  <!-- example of registering a query parser -->
  <!--
     <queryParser name="myparser" class="com.mycompany.MyQParserPlugin"/>
    -->

  <!-- Function Parsers

       http://wiki.apache.org/solr/FunctionQuery

       Multiple ValueSourceParsers can be registered by name, and then
       used as function names when using the "func" QParser.
    -->
  <!-- example of registering a custom function parser  -->
  <!--
     <valueSourceParser name="myfunc"
                        class="com.mycompany.MyValueSourceParser" />
    -->


  <!-- Document Transformers
       http://wiki.apache.org/solr/DocTransformers
    -->
  <!--
     Could be something like:
     <transformer name="db" class="com.mycompany.LoadFromDatabaseTransformer" >
       <int name="connection">jdbc://....</int>
     </transformer>

     To add a constant value to all docs, use:
     <transformer name="mytrans2" class="org.apache.solr.response.transform.ValueAugmenterFactory" >
       <int name="value">5</int>
     </transformer>

     If you want the user to still be able to change it with _value:something_ use this:
     <transformer name="mytrans3" class="org.apache.solr.response.transform.ValueAugmenterFactory" >
       <double name="defaultValue">5</double>
     </transformer>

      If you are using the QueryElevationComponent, you may wish to mark documents that get boosted.  The
      EditorialMarkerFactory will do exactly that:
     <transformer name="qecBooster" class="org.apache.solr.response.transform.EditorialMarkerFactory" />
    -->
</config>
                         xMPF�  xMPF�                               /configs/_default/lang����              #       #  xMPF�  xMPF�       '                   �   */configs/_default/lang/contractions_it.txt   �# Set of Italian contractions for ElisionFilter
# TODO: load this as a resource from the analyzer and sync it in build.xml
c
l 
all 
dall 
dell 
nell 
sull 
coll 
pell 
gl 
agl 
dagl 
degl 
negl 
sugl 
un 
m 
t 
s 
v 
d
              \       \  xMPG�  xMPG�                           \   &/configs/_default/lang/stemdict_nl.txt   �# Set of overrides for the dutch stemmer
# TODO: load this as a resource from the analyzer and sync it in build.xml
fiets	fiets
bromfiets	bromfiets
ei	eier
kind	kinder
              @       @  xMPG<  xMPG<                           @   '/configs/_default/lang/stopwords_no.txt  	 | From svn.tartarus.org/snowball/trunk/website/algorithms/norwegian/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Norwegian stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

 | This stop word list is for the dominant bokmål dialect. Words unique
 | to nynorsk are marked *.

 | Revised by Jan Bruusgaard <Jan.Bruusgaard@ssb.no>, Jan 2005

og             | and
i              | in
jeg            | I
det            | it/this/that
at             | to (w. inf.)
en             | a/an
et             | a/an
den            | it/this/that
til            | to
er             | is/am/are
som            | who/that
på             | on
de             | they / you(formal)
med            | with
han            | he
av             | of
ikke           | not
ikkje          | not *
der            | there
så             | so
var            | was/were
meg            | me
seg            | you
men            | but
ett            | one
har            | have
om             | about
vi             | we
min            | my
mitt           | my
ha             | have
hadde          | had
hun            | she
nå             | now
over           | over
da             | when/as
ved            | by/know
fra            | from
du             | you
ut             | out
sin            | your
dem            | them
oss            | us
opp            | up
man            | you/one
kan            | can
hans           | his
hvor           | where
eller          | or
hva            | what
skal           | shall/must
selv           | self (reflective)
sjøl           | self (reflective)
her            | here
alle           | all
vil            | will
bli            | become
ble            | became
blei           | became *
blitt          | have become
kunne          | could
inn            | in
når            | when
være           | be
kom            | come
noen           | some
noe            | some
ville          | would
dere           | you
som            | who/which/that
deres          | their/theirs
kun            | only/just
ja             | yes
etter          | after
ned            | down
skulle         | should
denne          | this
for            | for/because
deg            | you
si             | hers/his
sine           | hers/his
sitt           | hers/his
mot            | against
å              | to
meget          | much
hvorfor        | why
dette          | this
disse          | these/those
uten           | without
hvordan        | how
ingen          | none
din            | your
ditt           | your
blir           | become
samme          | same
hvilken        | which
hvilke         | which (plural)
sånn           | such a
inni           | inside/within
mellom         | between
vår            | our
hver           | each
hvem           | who
vors           | us/ours
hvis           | whose
både           | both
bare           | only/just
enn            | than
fordi          | as/because
før            | before
mange          | many
også           | also
slik           | just
vært           | been
være           | to be
båe            | both *
begge          | both
siden          | since
dykk           | your *
dykkar         | yours *
dei            | they *
deira          | them *
deires         | theirs *
deim           | them *
di             | your (fem.) *
då             | as/when *
eg             | I *
ein            | a/an *
eit            | a/an *
eitt           | a/an *
elles          | or *
honom          | he *
hjå            | at *
ho             | she *
hoe            | she *
henne          | her
hennar         | her/hers
hennes         | hers
hoss           | how *
hossen         | how *
ikkje          | not *
ingi           | noone *
inkje          | noone *
korleis        | how *
korso          | how *
kva            | what/which *
kvar           | where *
kvarhelst      | where *
kven           | who/whom *
kvi            | why *
kvifor         | why *
me             | we *
medan          | while *
mi             | my *
mine           | my *
mykje          | much *
no             | now *
nokon          | some (masc./neut.) *
noka           | some (fem.) *
nokor          | some *
noko           | some *
nokre          | some *
si             | his/hers *
sia            | since *
sidan          | since *
so             | so *
somt           | some *
somme          | some *
um             | about*
upp            | up *
vere           | be *
vore           | was *
verte          | become *
vort           | become *
varte          | became *
vart           | became *

              D       D  xMPGE  xMPGE                           D   */configs/_default/lang/contractions_ca.txt   �# Set of Catalan contractions for ElisionFilter
# TODO: load this as a resource from the analyzer and sync it in build.xml
d
l
m
n
s
t
              T       T  xMPGt  xMPGt                           T   '/configs/_default/lang/stopwords_hy.txt  N# example set of Armenian stopwords.
այդ
այլ
այն
այս
դու
դուք
եմ
են
ենք
ես
եք
է
էի
էին
էինք
էիր
էիք
էր
ըստ
թ
ի
ին
իսկ
իր
կամ
համար
հետ
հետո
մենք
մեջ
մի
ն
նա
նաև
նրա
նրանք
որ
որը
որոնք
որպես
ու
ում
պիտի
վրա
և
              �       �  xMPG�  xMPG�                           �   '/configs/_default/lang/stopwords_id.txt  
�# from appendix D of: A Study of Stemming Effects on Information
# Retrieval in Bahasa Indonesia
ada
adanya
adalah
adapun
agak
agaknya
agar
akan
akankah
akhirnya
aku
akulah
amat
amatlah
anda
andalah
antar
diantaranya
antara
antaranya
diantara
apa
apaan
mengapa
apabila
apakah
apalagi
apatah
atau
ataukah
ataupun
bagai
bagaikan
sebagai
sebagainya
bagaimana
bagaimanapun
sebagaimana
bagaimanakah
bagi
bahkan
bahwa
bahwasanya
sebaliknya
banyak
sebanyak
beberapa
seberapa
begini
beginian
beginikah
beginilah
sebegini
begitu
begitukah
begitulah
begitupun
sebegitu
belum
belumlah
sebelum
sebelumnya
sebenarnya
berapa
berapakah
berapalah
berapapun
betulkah
sebetulnya
biasa
biasanya
bila
bilakah
bisa
bisakah
sebisanya
boleh
bolehkah
bolehlah
buat
bukan
bukankah
bukanlah
bukannya
cuma
percuma
dahulu
dalam
dan
dapat
dari
daripada
dekat
demi
demikian
demikianlah
sedemikian
dengan
depan
di
dia
dialah
dini
diri
dirinya
terdiri
dong
dulu
enggak
enggaknya
entah
entahlah
terhadap
terhadapnya
hal
hampir
hanya
hanyalah
harus
haruslah
harusnya
seharusnya
hendak
hendaklah
hendaknya
hingga
sehingga
ia
ialah
ibarat
ingin
inginkah
inginkan
ini
inikah
inilah
itu
itukah
itulah
jangan
jangankan
janganlah
jika
jikalau
juga
justru
kala
kalau
kalaulah
kalaupun
kalian
kami
kamilah
kamu
kamulah
kan
kapan
kapankah
kapanpun
dikarenakan
karena
karenanya
ke
kecil
kemudian
kenapa
kepada
kepadanya
ketika
seketika
khususnya
kini
kinilah
kiranya
sekiranya
kita
kitalah
kok
lagi
lagian
selagi
lah
lain
lainnya
melainkan
selaku
lalu
melalui
terlalu
lama
lamanya
selama
selama
selamanya
lebih
terlebih
bermacam
macam
semacam
maka
makanya
makin
malah
malahan
mampu
mampukah
mana
manakala
manalagi
masih
masihkah
semasih
masing
mau
maupun
semaunya
memang
mereka
merekalah
meski
meskipun
semula
mungkin
mungkinkah
nah
namun
nanti
nantinya
nyaris
oleh
olehnya
seorang
seseorang
pada
padanya
padahal
paling
sepanjang
pantas
sepantasnya
sepantasnyalah
para
pasti
pastilah
per
pernah
pula
pun
merupakan
rupanya
serupa
saat
saatnya
sesaat
saja
sajalah
saling
bersama
sama
sesama
sambil
sampai
sana
sangat
sangatlah
saya
sayalah
se
sebab
sebabnya
sebuah
tersebut
tersebutlah
sedang
sedangkan
sedikit
sedikitnya
segala
segalanya
segera
sesegera
sejak
sejenak
sekali
sekalian
sekalipun
sesekali
sekaligus
sekarang
sekarang
sekitar
sekitarnya
sela
selain
selalu
seluruh
seluruhnya
semakin
sementara
sempat
semua
semuanya
sendiri
sendirinya
seolah
seperti
sepertinya
sering
seringnya
serta
siapa
siapakah
siapapun
disini
disinilah
sini
sinilah
sesuatu
sesuatunya
suatu
sesudah
sesudahnya
sudah
sudahkah
sudahlah
supaya
tadi
tadinya
tak
tanpa
setelah
telah
tentang
tentu
tentulah
tentunya
tertentu
seterusnya
tapi
tetapi
setiap
tiap
setidaknya
tidak
tidakkah
tidaklah
toh
waduh
wah
wahai
sewaktu
walau
walaupun
wong
yaitu
yakni
yang
              �       �  xMPH  xMPH                           �   '/configs/_default/lang/stopwords_et.txt  ,
# Estonian stopwords list
all
alla
allapoole
allpool
alt
altpoolt
eel
eespool
enne
hommikupoole
hoolimata
ilma
kaudu
keset
kesk
kohe
koos
kuhupoole
kuni
kuspool
kustpoolt
kõige
käsikäes
lappi
ligi
läbi
mööda
paitsi
peale
pealepoole
pealpool
pealt
pealtpoolt
piki
pikku
piku
pikuti
põiki
pärast
päri
risti
sealpool
sealtpoolt
seespool
seltsis
siiapoole
siinpool
siitpoolt
sinnapoole
sissepoole
taga
tagantpoolt
tagapidi
tagapool
taha
tahapoole
teispool
teispoole
tänu
tükkis
vaatamata
vastu
väljapoole
väljaspool
väljastpoolt
õhtupoole
ühes
ühestükis
ühestükkis
ülalpool
ülaltpoolt
üle
ülespoole
ülevalpool
ülevaltpoolt
ümber
ümbert
aegu
aegus
alguks
algul
algule
algult
alguni
all
alla
alt
alul
alutsi
arvel
asemel
asemele
eel
eeli
ees
eesotsas
eest
eestotsast
esitsi
ette
etteotsa
haaval
heaks
hoolimata
hulgas
hulgast
hulka
jalgu
jalus
jalust
jaoks
jooksul
juurde
juures
juurest
jälil
jälile
järel
järele
järelt
järgi
kaasas
kallal
kallale
kallalt
kamul
kannul
kannule
kannult
kaudu
kaupa
keskel
keskele
keskelt
keskis
keskpaiku
kestel
kestes
kilda
killas
killast
kimpu
kimpus
kiuste
kohal
kohale
kohalt
kohaselt
kohe
kohta
koos
korral
kukil
kukile
kukilt
kulul
kõrva
kõrval
kõrvale
kõrvalt
kõrvas
kõrvast
käekõrval
käekõrvale
käekõrvalt
käes
käest
kätte
külge
küljes
küljest
küüsi
küüsis
küüsist
ligi
ligidal
ligidale
ligidalt
aegu
aegus
alguks
algul
algule
algult
alguni
all
alla
alt
alul
alutsi
arvel
asemel
asemele
eel
eeli
ees
eesotsas
eest
eestotsast
esitsi
ette
etteotsa
haaval
heaks
hoolimata
hulgas
hulgast
hulka
jalgu
jalus
jalust
jaoks
jooksul
juurde
juures
juurest
jälil
jälile
järel
järele
järelt
järgi
kaasas
kallal
kallale
kallalt
kamul
kannul
kannule
kannult
kaudu
kaupa
keskel
keskele
keskelt
keskis
keskpaiku
kestel
kestes
kilda
killas
killast
kimpu
kimpus
kiuste
kohal
kohale
kohalt
kohaselt
kohe
kohta
koos
korral
kukil
kukile
kukilt
kulul
kõrva
kõrval
kõrvale
kõrvalt
kõrvas
kõrvast
käekõrval
käekõrvale
käekõrvalt
käes
käest
kätte
külge
küljes
küljest
küüsi
küüsis
küüsist
ligi
ligidal
ligidale
ligidalt
lool
läbi
lähedal
lähedale
lähedalt
man
mant
manu
meelest
mööda
nahas
nahka
nahkas
najal
najale
najalt
nõjal
nõjale
otsa
otsas
otsast
paigale
paigu
paiku
peal
peale
pealt
perra
perrä
pidi
pihta
piki
pikku
pool
poole
poolest
poolt
puhul
puksiiris
pähe
päralt
päras
pärast
päri
ringi
ringis
risust
saadetusel
saadik
saatel
saati
seas
seast
sees
seest
sekka
seljataga
seltsi
seltsis
seltsist
sisse
slepis
suhtes
šlepis
taga
tagant
tagantotsast
tagaotsas
tagaselja
tagasi
tagast
tagutsi
taha
tahaotsa
takka
tarvis
tasa
tuuri
tuuris
tõttu
tükkis
uhal
vaatamata
vahel
vahele
vahelt
vahepeal
vahepeale
vahepealt
vahetsi
varal
varale
varul
vastas
vastast
vastu
veerde
veeres
viisi
võidu
võrd
võrdki
võrra
võrragi
väel
väele
vältel
väärt
väärtki
äärde
ääre
ääres
äärest
ühes
üle
ümber
ümbert
a
abil
aina
ainult
alalt
alates
alati
alles
b
c
d
e
eales
ealeski
edasi
edaspidi
eelkõige
eemal
ei
eks
end
enda
enese
ennem
esialgu
f
g
h
hoopis
i
iganes
igatahes
igati
iial
iialgi
ikka
ikkagi
ilmaski
iseenda
iseenese
iseenesest
isegi
j
jah
ju
juba
juhul
just
järelikult
k
ka
kah
kas
kasvõi
keda
kestahes
kogu
koguni
kohati
kokku
kuhu
kuhugi
kuidagi
kuidas
kunagi
kus
kusagil
kusjuures
kuskil
kust
kõigepealt
küll
l
liiga
lisaks
m
miks
mil
millal
millalgi
mispärast
mistahes
mistõttu
mitte
muide
muidu
muidugi
muist
mujal
mujale
mujalt
mõlemad
mõnda
mõne
mõnikord
n
nii
niikaua
niimoodi
niipaljuke
niisama
niisiis
niivõrd
nõnda
nüüd
o
omaette
omakorda
omavahel
ometi
p
palju
paljuke
palju-palju
peaaegu
peagi
peamiselt
pigem
pisut
praegu
päris
r
rohkem
s
samas
samuti
seal
sealt
sedakorda
sedapuhku
seega
seejuures
seejärel
seekord
seepärast
seetõttu
sellepärast
seni
sestap
siia
siiani
siin
siinkohal
siis
siiski
siit
sinna
suht
š
z
ž
t
teel
teineteise
tõesti
täiesti
u
umbes
v
w
veel
veelgi
vist
võibolla
võib-olla
väga
vähemalt
välja
väljas
väljast
õ
ä
ära
ö
ü
ühtlasi
üksi
ükskõik
ülal
ülale
ülalt
üles
ülesse
üleval
ülevalt
ülimalt
üsna
x
y
aga
ega
ehk
ehkki
elik
ellik
enge
ennegu
ent
et
ja
justkui
kui
kuid
kuigi
kuivõrd
kuna
kuni
kut
mistab
muudkui
nagu
nigu
ning
olgugi
otsekui
otsenagu
selmet
sest
sestab
vaid
või
aa
adaa
adjöö
ae
ah
ahaa
ahah
ah-ah-ah
ah-haa
ahoi
ai
aidaa
aidu-raidu
aih
aijeh
aituma
aitäh
aitüma
ammuu
amps
ampsti
aptsih
ass
at
ata
at-at-at
atsih
atsihh
auh
bai-bai
bingo
braavo
brr
ee
eeh
eh
ehee
eheh
eh-eh-hee
eh-eh-ee
ehei
ehh
ehhee
einoh
ena
ennäe
ennäh
fuh
fui
fuih
haa
hah
hahaa
hah-hah-hah
halleluuja
hallo
halloo
hass
hee
heh
he-he-hee
hei
heldeke(ne)
heureka
hihii
hip-hip-hurraa
hmh
hmjah
hoh-hoh-hoo
hohoo
hoi
hollallaa
hoo
hoplaa
hopp
hops
hopsassaa
hopsti
hosianna
huh
huidii
huist
hurjah
hurjeh
hurjoh
hurjuh
hurraa
huu
hõhõh
hõi
hõissa
hõissassa
hõk
hõkk
häh
hä-hä-hää
hüvasti
ih-ah-haa
ih-ih-hii
ii-ha-ha
issake
issakene
isver
jaa-ah
ja-ah
jaah
janäe
jeeh
jeerum
jeever
jessas
jestas
juhhei
jumalaga
jumalime
jumaluke
jumalukene
jutas
kaaps
kaapsti
kaasike
kae
kalps
kalpsti
kannäe
kanäe
kappadi
kaps
kapsti
karkõmm
karkäuh
karkääks
karkääksti
karmauh
karmauhti
karnaps
karnapsti
karniuhti
karpartsaki
karpauh
karpauhti
karplauh
karplauhti
karprauh
karprauhti
karsumdi
karsumm
kartsumdi
kartsumm
karviuh
karviuhti
kaske
kassa
kauh
kauhti
keh
keksti
kepsti
khe
khm
kih
kiiks
kiiksti
kiis
kiiss
kikerii
kikerikii
kili
kilk
kilk-kõlk
kilks
kilks-kolks
kilks-kõlks
kill
killadi
killadi|-kolladi
killadi-kõlladi
killa-kolla
killa-kõlla
kill-kõll
kimps-komps
kipp
kips-kõps
kiriküüt
kirra-kõrra
kirr-kõrr
kirts
klaps
klapsti
klirdi
klirr
klonks
klops
klopsti
kluk
klu-kluu
klõks
klõksti
klõmdi
klõmm
klõmpsti
klõnks
klõnksti
klõps
klõpsti
kläu
kohva-kohva
kok
koks
koksti
kolaki
kolk
kolks
kolksti
koll
kolladi
komp
komps
kompsti
kop
kopp
koppadi
kops
kopsti
kossu
kotsu
kraa
kraak
kraaks
kraaps
kraapsti
krahh
kraks
kraksti
kraps
krapsti
krauh
krauhti
kriiks
kriiksti
kriips
kriips-kraaps
kripa-krõpa
krips-kraps
kriuh
kriuks
kriuksti
kromps
kronk
kronks
krooks
kruu
krõks
krõksti
krõpa
krõps
krõpsti
krõuh
kräu
kräuh
kräuhti
kräuks
kss
kukeleegu
kukku
kuku
kulu
kurluu
kurnäu
kuss
kussu
kõks
kõksti
kõldi
kõlks
kõlksti
kõll
kõmaki
kõmdi
kõmm
kõmps
kõpp
kõps
kõpsadi
kõpsat
kõpsti
kõrr
kõrra-kõrra
kõss
kõtt
kõõksti
kärr
kärts
kärtsti
käuks
käuksti
kääga
kääks
kääksti
köh
köki-möki
köksti
laks
laksti
lampsti
larts
lartsti
lats
latsti
leelo
legoo
lehva
liiri-lõõri
lika-lõka
likat-lõkat
limpsti
lips
lipsti
lirts
lirtsaki
lirtsti
lonksti
lops
lopsti
lorts
lortsti
luks
lups
lupsti
lurts
lurtsti
lõks
lõksti
lõmps
lõmpsti
lõnks
lõnksti
lärts
lärtsti
läts
lätsti
lörts
lörtsti
lötsti
lööps
lööpsti
marss
mats
matsti
mauh
mauhti
mh
mhh
mhmh
miau
mjaa
mkm
m-mh
mnjaa
mnjah
moens
mulks
mulksti
mull-mull
mull-mull-mull
muu
muuh
mõh
mõmm
mäh
mäts
mäu
mää
möh
möh-öh-ää
möö
müh-müh
mühüh
müks
müksti
müraki
mürr
mürts
mürtsaki
mürtsti
mütaku
müta-mäta
müta-müta
müt-müt
müt-müt-müt
müts
mütsti
mütt
naa
naah
nah
naks
naksti
nanuu
naps
napsti
nilpsti
nipsti
nirr
niuh
niuh-näuh
niuhti
noh
noksti
nolpsti
nonoh
nonoo
nonäh
noo
nooh
nooks
norr
nurr
nuuts
nõh
nõhh
nõka-nõka
nõks
nõksat-nõksat
nõks-nõks
nõksti
nõõ
nõõh
näeh
näh
nälpsti
nämm-nämm
näpsti
näts
nätsti
näu
näuh
näuhti
näuks
näuksti
nääh
nääks
nühkat-nühkat
oeh
oh
ohh
ohhh
oh-hoi
oh-hoo
ohoh
oh-oh-oo
oh-oh-hoo
ohoi
ohoo
oi
oih
oijee
oijeh
oo
ooh
oo-oh
oo-ohh
oot
ossa
ot
paa
pah
pahh
pakaa
pamm
pantsti
pardon
pardonks
parlartsti
parts
partsti
partsumdi
partsumm
pastoi
pats
patst
patsti
pau
pauh
pauhti
pele
pfui
phuh
phuuh
phäh
phähh
piiks
piip
piiri-pääri
pimm
pimm-pamm
pimm-pomm
pimm-põmm
piraki
piuks
piu-pau
plaks
plaksti
plarts
plartsti
plats
platsti
plauh
plauhh
plauhti
pliks
pliks-plaks
plinn
pliraki
plirts
plirtsti
pliu
pliuh
ploks
plotsti
plumps
plumpsti
plõks
plõksti
plõmdi
plõmm
plõnn
plärr
plärts
plärtsat
plärtsti
pläu
pläuh
plää
plörtsat
pomm
popp
pops
popsti
ports
pot
pots
potsti
pott
praks
praksti
prants
prantsaki
prantsti
prassai
prauh
prauhh
prauhti
priks
priuh
priuhh
priuh-prauh
proosit
proost
prr
prrr
prõks
prõksti
prõmdi
prõmm
prõntsti
prääk
prääks
pst
psst
ptrr
ptruu
ptüi
puh
puhh
puksti
pumm
pumps
pup-pup-pup
purts
puuh
põks
põksti
põmdi
põmm
põmmadi
põnks
põnn
põnnadi
põnt
põnts
põntsti
põraki
põrr
põrra-põrra
päh
pähh
päntsti
pää
pöörd
püh
raks
raksti
raps
rapsti
ratataa
rauh
riips
riipsti
riks
riks-raks
rips-raps
rivitult
robaki
rops
ropsaki
ropsti
ruik
räntsti
räts
röh
röhh
sah
sahh
sahkat
saps
sapsti
sauh
sauhti
servus
sihkadi-sahkadi
sihka-sahka
sihkat-sahkat
silks
silk-solk
sips
sipsti
sirr
sirr-sorr
sirts
sirtsti
siu
siuh
siuh-sauh
siuh-säuh
siuhti
siuks
siuts
skool
so
soh
solks
solksti
solpsti
soo
sooh
so-oh
soo-oh
sopp
sops
sopsti
sorr
sorts
sortsti
so-soo
soss
soss-soss
ss
sss
sst
stopp
suhkat-sahkat
sulk
sulks
sulksti
sull
sulla-sulla
sulpa-sulpa
sulps
sulpsti
sumaki
sumdi
summ
summat-summat
sups
supsaku
supsti
surts
surtsti
suss
susti
suts
sutsti
säh
sähke
särts
särtsti
säu
säuh
säuhti
taevake
taevakene
takk
tere
terekest
tibi-tibi
tikk-takk
tiks
tilk
tilks
till
tilla-talla
till-tall
tilulii
tinn
tip
tip-tap
tirr
tirtsti
tiu
tjaa
tjah
tohhoh
tohhoo
tohoh
tohoo
tok
tokk
toks
toksti
tonks
tonksti
tota
totsti
tot-tot
tprr
tpruu
trah
trahh
trallallaa
trill
trillallaa
trr
trrr
tsah
tsahh
tsilk
tsilk-tsolk
tsirr
tsiuh
tskae
tsolk
tss
tst
tsst
tsuhh
tsuk
tsumm
tsurr
tsäuh
tšao
tšš
tššš
tuk
tuks
turts
turtsti
tutki
tutkit
tutu-lutu
tutulutu
tuut
tuutu-luutu
tõks
tötsti
tümps
uh
uhh
uh-huu
uhtsa
uhtsaa
uhuh
uhuu
ui
uih
uih-aih
uijah
uijeh
uist
uit
uka
upsti
uraa
urjah
urjeh
urjoh
urjuh
urr
urraa
ust
utu
uu
uuh
vaak
vaat
vae
vaeh
vai
vat
vau
vhüüt
vidiit
viiks
vilks
vilksti
vinki-vinki
virdi
virr
viu
viudi
viuh
viuhti
voeh
voh
vohh
volks
volksti
vooh
vops
vopsti
vot
vuh
vuhti
vuih
vulks
vulksti
vull
vulpsti
vups
vupsaki
vupsaku
vupsti
vurdi
vurr
vurra-vurra
vurts
vurtsti
vutt
võe
võeh
või
võih
võrr
võts
võtt
vääks
õe
õits
õk
õkk
õrr
õss
õuh
äh
ähh
ähhähhää
äh-hää
äh-äh-hää
äiu
äiu-ää
äss
ää
ääh
äähh
öh
öhh
ök
üh
eelmine
eikeegi
eimiski
emb-kumb
enam
enim
iga
igasugune
igaüks
ise
isesugune
järgmine
keegi
kes
kumb
kumbki
kõik
meiesugune
meietaoline
midagi
mihuke
mihukene
milletaoline
milline
mina
minake
mingi
mingisugune
minusugune
minutaoline
mis
miski
miskisugune
missugune
misuke
mitmes
mitmesugune
mitu
mitu-mitu
mitu-setu
muu
mõlema
mõnesugune
mõni
mõningane
mõningas
mäherdune
määrane
naasugune
need
nemad
nendesugune
nendetaoline
nihuke
nihukene
niimitu
niisamasugune
niisugune
nisuke
nisukene
oma
omaenese
omasugune
omataoline
pool
praegune
sama
samasugune
samataoline
see
seesama
seesamane
seesamune
seesinane
seesugune
selline
sihuke
sihukene
sina
sinusugune
sinutaoline
siuke
siukene
säherdune
säärane
taoline
teiesugune
teine
teistsugune
tema
temake
temakene
temasugune
temataoline
too
toosama
toosamane
üks
üksteise
hakkama
minema
olema
pidama
saama
tegema
tulema
võima
              d       d  xMPG�  xMPG�                           d   '/configs/_default/lang/stopwords_ga.txt  )
a
ach
ag
agus
an
aon
ar
arna
as
b'
ba
beirt
bhúr
caoga
ceathair
ceathrar
chomh
chtó
chuig
chun
cois
céad
cúig
cúigear
d'
daichead
dar
de
deich
deichniúr
den
dhá
do
don
dtí
dá
dár
dó
faoi
faoin
faoina
faoinár
fara
fiche
gach
gan
go
gur
haon
hocht
i
iad
idir
in
ina
ins
inár
is
le
leis
lena
lenár
m'
mar
mo
mé
na
nach
naoi
naonúr
ná
ní
níor
nó
nócha
ocht
ochtar
os
roimh
sa
seacht
seachtar
seachtó
seasca
seisear
siad
sibh
sinn
sna
sé
sí
tar
thar
thú
triúr
trí
trína
trínár
tríocha
tú
um
ár
é
éis
í
ó
ón
óna
ónár
              X       X  xMPG~  xMPG~                           X   '/configs/_default/lang/stopwords_da.txt  � | From svn.tartarus.org/snowball/trunk/website/algorithms/danish/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Danish stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

 | This is a ranked list (commonest to rarest) of stopwords derived from
 | a large text sample.


og           | and
i            | in
jeg          | I
det          | that (dem. pronoun)/it (pers. pronoun)
at           | that (in front of a sentence)/to (with infinitive)
en           | a/an
den          | it (pers. pronoun)/that (dem. pronoun)
til          | to/at/for/until/against/by/of/into, more
er           | present tense of "to be"
som          | who, as
på           | on/upon/in/on/at/to/after/of/with/for, on
de           | they
med          | with/by/in, along
han          | he
af           | of/by/from/off/for/in/with/on, off
for          | at/for/to/from/by/of/ago, in front/before, because
ikke         | not
der          | who/which, there/those
var          | past tense of "to be"
mig          | me/myself
sig          | oneself/himself/herself/itself/themselves
men          | but
et           | a/an/one, one (number), someone/somebody/one
har          | present tense of "to have"
om           | round/about/for/in/a, about/around/down, if
vi           | we
min          | my
havde        | past tense of "to have"
ham          | him
hun          | she
nu           | now
over         | over/above/across/by/beyond/past/on/about, over/past
da           | then, when/as/since
fra          | from/off/since, off, since
du           | you
ud           | out
sin          | his/her/its/one's
dem          | them
os           | us/ourselves
op           | up
man          | you/one
hans         | his
hvor         | where
eller        | or
hvad         | what
skal         | must/shall etc.
selv         | myself/youself/herself/ourselves etc., even
her          | here
alle         | all/everyone/everybody etc.
vil          | will (verb)
blev         | past tense of "to stay/to remain/to get/to become"
kunne        | could
ind          | in
når          | when
være         | present tense of "to be"
dog          | however/yet/after all
noget        | something
ville        | would
jo           | you know/you see (adv), yes
deres        | their/theirs
efter        | after/behind/according to/for/by/from, later/afterwards
ned          | down
skulle       | should
denne        | this
end          | than
dette        | this
mit          | my/mine
også         | also
under        | under/beneath/below/during, below/underneath
have         | have
dig          | you
anden        | other
hende        | her
mine         | my
alt          | everything
meget        | much/very, plenty of
sit          | his, her, its, one's
sine         | his, her, its, one's
vor          | our
mod          | against
disse        | these
hvis         | if
din          | your/yours
nogle        | some
hos          | by/at
blive        | be/become
mange        | many
ad           | by/through
bliver       | present tense of "to be/to become"
hendes       | her/hers
været        | be
thi          | for (conj)
jer          | you
sådan        | such, like this/like that
              �       �  xMPG�  xMPG�                           �   '/configs/_default/lang/stopwords_hi.txt  �# Also see http://www.opensource.org/licenses/bsd-license.html
# See http://members.unine.ch/jacques.savoy/clef/index.html.
# This file was created by Jacques Savoy and is distributed under the BSD license.
# Note: by default this file also contains forms normalized by HindiNormalizer 
# for spelling variation (see section below), such that it can be used whether or 
# not you enable that feature. When adding additional entries to this list,
# please add the normalized form as well. 
अंदर
अत
अपना
अपनी
अपने
अभी
आदि
आप
इत्यादि
इन 
इनका
इन्हीं
इन्हें
इन्हों
इस
इसका
इसकी
इसके
इसमें
इसी
इसे
उन
उनका
उनकी
उनके
उनको
उन्हीं
उन्हें
उन्हों
उस
उसके
उसी
उसे
एक
एवं
एस
ऐसे
और
कई
कर
करता
करते
करना
करने
करें
कहते
कहा
का
काफ़ी
कि
कितना
किन्हें
किन्हों
किया
किर
किस
किसी
किसे
की
कुछ
कुल
के
को
कोई
कौन
कौनसा
गया
घर
जब
जहाँ
जा
जितना
जिन
जिन्हें
जिन्हों
जिस
जिसे
जीधर
जैसा
जैसे
जो
तक
तब
तरह
तिन
तिन्हें
तिन्हों
तिस
तिसे
तो
था
थी
थे
दबारा
दिया
दुसरा
दूसरे
दो
द्वारा
न
नहीं
ना
निहायत
नीचे
ने
पर
पर  
पहले
पूरा
पे
फिर
बनी
बही
बहुत
बाद
बाला
बिलकुल
भी
भीतर
मगर
मानो
मे
में
यदि
यह
यहाँ
यही
या
यिह 
ये
रखें
रहा
रहे
ऱ्वासा
लिए
लिये
लेकिन
व
वर्ग
वह
वह 
वहाँ
वहीं
वाले
वुह 
वे
वग़ैरह
संग
सकता
सकते
सबसे
सभी
साथ
साबुत
साभ
सारा
से
सो
ही
हुआ
हुई
हुए
है
हैं
हो
होता
होती
होते
होना
होने
# additional normalized forms of the above
अपनि
जेसे
होति
सभि
तिंहों
इंहों
दवारा
इसि
किंहें
थि
उंहों
ओर
जिंहें
वहिं
अभि
बनि
हि
उंहिं
उंहें
हें
वगेरह
एसे
रवासा
कोन
निचे
काफि
उसि
पुरा
भितर
हे
बहि
वहां
कोइ
यहां
जिंहों
तिंहें
किसि
कइ
यहि
इंहिं
जिधर
इंहें
अदि
इतयादि
हुइ
कोनसा
इसकि
दुसरे
जहां
अप
किंहों
उनकि
भि
वरग
हुअ
जेसा
नहिं
              �       �  xMPH  xMPH                           �   '/configs/_default/lang/stopwords_pt.txt   | From svn.tartarus.org/snowball/trunk/website/algorithms/portuguese/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Portuguese stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.


 | The following is a ranked list (commonest to rarest) of stopwords
 | deriving from a large sample of text.

 | Extra words have been added at the end.

de             |  of, from
a              |  the; to, at; her
o              |  the; him
que            |  who, that
e              |  and
do             |  de + o
da             |  de + a
em             |  in
um             |  a
para           |  for
  | é          from SER
com            |  with
não            |  not, no
uma            |  a
os             |  the; them
no             |  em + o
se             |  himself etc
na             |  em + a
por            |  for
mais           |  more
as             |  the; them
dos            |  de + os
como           |  as, like
mas            |  but
  | foi        from SER
ao             |  a + o
ele            |  he
das            |  de + as
  | tem        from TER
à              |  a + a
seu            |  his
sua            |  her
ou             |  or
  | ser        from SER
quando         |  when
muito          |  much
  | há         from HAV
nos            |  em + os; us
já             |  already, now
  | está       from EST
eu             |  I
também         |  also
só             |  only, just
pelo           |  per + o
pela           |  per + a
até            |  up to
isso           |  that
ela            |  he
entre          |  between
  | era        from SER
depois         |  after
sem            |  without
mesmo          |  same
aos            |  a + os
  | ter        from TER
seus           |  his
quem           |  whom
nas            |  em + as
me             |  me
esse           |  that
eles           |  they
  | estão      from EST
você           |  you
  | tinha      from TER
  | foram      from SER
essa           |  that
num            |  em + um
nem            |  nor
suas           |  her
meu            |  my
às             |  a + as
minha          |  my
  | têm        from TER
numa           |  em + uma
pelos          |  per + os
elas           |  they
  | havia      from HAV
  | seja       from SER
qual           |  which
  | será       from SER
nós            |  we
  | tenho      from TER
lhe            |  to him, her
deles          |  of them
essas          |  those
esses          |  those
pelas          |  per + as
este           |  this
  | fosse      from SER
dele           |  of him

 | other words. There are many contractions such as naquele = em+aquele,
 | mo = me+o, but they are rare.
 | Indefinite article plural forms are also rare.

tu             |  thou
te             |  thee
vocês          |  you (plural)
vos            |  you
lhes           |  to them
meus           |  my
minhas
teu            |  thy
tua
teus
tuas
nosso          | our
nossa
nossos
nossas

dela           |  of her
delas          |  of them

esta           |  this
estes          |  these
estas          |  these
aquele         |  that
aquela         |  that
aqueles        |  those
aquelas        |  those
isto           |  this
aquilo         |  that

               | forms of estar, to be (not including the infinitive):
estou
está
estamos
estão
estive
esteve
estivemos
estiveram
estava
estávamos
estavam
estivera
estivéramos
esteja
estejamos
estejam
estivesse
estivéssemos
estivessem
estiver
estivermos
estiverem

               | forms of haver, to have (not including the infinitive):
hei
há
havemos
hão
houve
houvemos
houveram
houvera
houvéramos
haja
hajamos
hajam
houvesse
houvéssemos
houvessem
houver
houvermos
houverem
houverei
houverá
houveremos
houverão
houveria
houveríamos
houveriam

               | forms of ser, to be (not including the infinitive):
sou
somos
são
era
éramos
eram
fui
foi
fomos
foram
fora
fôramos
seja
sejamos
sejam
fosse
fôssemos
fossem
for
formos
forem
serei
será
seremos
serão
seria
seríamos
seriam

               | forms of ter, to have (not including the infinitive):
tenho
tem
temos
tém
tinha
tínhamos
tinham
tive
teve
tivemos
tiveram
tivera
tivéramos
tenha
tenhamos
tenham
tivesse
tivéssemos
tivessem
tiver
tivermos
tiverem
terei
terá
teremos
terão
teria
teríamos
teriam
              ,       ,  xMPG  xMPG                           ,   '/configs/_default/lang/stopwords_ja.txt  #
# This file defines a stopword set for Japanese.
#
# This set is made up of hand-picked frequent terms from segmented Japanese Wikipedia.
# Punctuation characters and frequent kanji have mostly been left out.  See LUCENE-3745
# for frequency lists, etc. that can be useful for making your own set (if desired)
#
# Note that there is an overlap between these stopwords and the terms stopped when used
# in combination with the JapanesePartOfSpeechStopFilter.  When editing this file, note
# that comments are not allowed on the same line as stopwords.
#
# Also note that stopping is done in a case-insensitive manner.  Change your StopFilter
# configuration if you need case-sensitive stopping.  Lastly, note that stopping is done
# using the same character width as the entries in this file.  Since this StopFilter is
# normally done after a CJKWidthFilter in your chain, you would usually want your romaji
# entries to be in half-width and your kana entries to be in full-width.
#
の
に
は
を
た
が
で
て
と
し
れ
さ
ある
いる
も
する
から
な
こと
として
い
や
れる
など
なっ
ない
この
ため
その
あっ
よう
また
もの
という
あり
まで
られ
なる
へ
か
だ
これ
によって
により
おり
より
による
ず
なり
られる
において
ば
なかっ
なく
しかし
について
せ
だっ
その後
できる
それ
う
ので
なお
のみ
でき
き
つ
における
および
いう
さらに
でも
ら
たり
その他
に関する
たち
ます
ん
なら
に対して
特に
せる
及び
これら
とき
では
にて
ほか
ながら
うち
そして
とともに
ただし
かつて
それぞれ
または
お
ほど
ものの
に対する
ほとんど
と共に
といった
です
とも
ところ
ここ
##### End of file
              �       �  xMPHg  xMPHg                           �   '/configs/_default/lang/stopwords_hu.txt  � | From svn.tartarus.org/snowball/trunk/website/algorithms/hungarian/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"
 
| Hungarian stop word list
| prepared by Anna Tordai

a
ahogy
ahol
aki
akik
akkor
alatt
által
általában
amely
amelyek
amelyekben
amelyeket
amelyet
amelynek
ami
amit
amolyan
amíg
amikor
át
abban
ahhoz
annak
arra
arról
az
azok
azon
azt
azzal
azért
aztán
azután
azonban
bár
be
belül
benne
cikk
cikkek
cikkeket
csak
de
e
eddig
egész
egy
egyes
egyetlen
egyéb
egyik
egyre
ekkor
el
elég
ellen
elő
először
előtt
első
én
éppen
ebben
ehhez
emilyen
ennek
erre
ez
ezt
ezek
ezen
ezzel
ezért
és
fel
felé
hanem
hiszen
hogy
hogyan
igen
így
illetve
ill.
ill
ilyen
ilyenkor
ison
ismét
itt
jó
jól
jobban
kell
kellett
keresztül
keressünk
ki
kívül
között
közül
legalább
lehet
lehetett
legyen
lenne
lenni
lesz
lett
maga
magát
majd
majd
már
más
másik
meg
még
mellett
mert
mely
melyek
mi
mit
míg
miért
milyen
mikor
minden
mindent
mindenki
mindig
mint
mintha
mivel
most
nagy
nagyobb
nagyon
ne
néha
nekem
neki
nem
néhány
nélkül
nincs
olyan
ott
össze
ő
ők
őket
pedig
persze
rá
s
saját
sem
semmi
sok
sokat
sokkal
számára
szemben
szerint
szinte
talán
tehát
teljes
tovább
továbbá
több
úgy
ugyanis
új
újabb
újra
után
utána
utolsó
vagy
vagyis
valaki
valami
valamint
való
vagyok
van
vannak
volt
voltam
voltak
voltunk
vissza
vele
viszont
volna
              $       $  xMPF�  xMPF�                           $   '/configs/_default/lang/stopwords_el.txt  !# Lucene Greek Stopwords list
# Note: by default this file is used after GreekLowerCaseFilter,
# so when modifying this file use 'σ' instead of 'ς' 
ο
η
το
οι
τα
του
τησ
των
τον
την
και 
κι
κ
ειμαι
εισαι
ειναι
ειμαστε
ειστε
στο
στον
στη
στην
μα
αλλα
απο
για
προσ
με
σε
ωσ
παρα
αντι
κατα
μετα
θα
να
δε
δεν
μη
μην
επι
ενω
εαν
αν
τοτε
που
πωσ
ποιοσ
ποια
ποιο
ποιοι
ποιεσ
ποιων
ποιουσ
αυτοσ
αυτη
αυτο
αυτοι
αυτων
αυτουσ
αυτεσ
αυτα
εκεινοσ
εκεινη
εκεινο
εκεινοι
εκεινεσ
εκεινα
εκεινων
εκεινουσ
οπωσ
ομωσ
ισωσ
οσο
οτι
              |       |  xMPG�  xMPG�                           |   '/configs/_default/lang/stopwords_ru.txt  � | From svn.tartarus.org/snowball/trunk/website/algorithms/russian/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | a russian stop word list. comments begin with vertical bar. each stop
 | word is at the start of a line.

 | this is a ranked list (commonest to rarest) of stopwords derived from
 | a large text sample.

 | letter `ё' is translated to `е'.

и              | and
в              | in/into
во             | alternative form
не             | not
что            | what/that
он             | he
на             | on/onto
я              | i
с              | from
со             | alternative form
как            | how
а              | milder form of `no' (but)
то             | conjunction and form of `that'
все            | all
она            | she
так            | so, thus
его            | him
но             | but
да             | yes/and
ты             | thou
к              | towards, by
у              | around, chez
же             | intensifier particle
вы             | you
за             | beyond, behind
бы             | conditional/subj. particle
по             | up to, along
только         | only
ее             | her
мне            | to me
было           | it was
вот            | here is/are, particle
от             | away from
меня           | me
еще            | still, yet, more
нет            | no, there isnt/arent
о              | about
из             | out of
ему            | to him
теперь         | now
когда          | when
даже           | even
ну             | so, well
вдруг          | suddenly
ли             | interrogative particle
если           | if
уже            | already, but homonym of `narrower'
или            | or
ни             | neither
быть           | to be
был            | he was
него           | prepositional form of его
до             | up to
вас            | you accusative
нибудь         | indef. suffix preceded by hyphen
опять          | again
уж             | already, but homonym of `adder'
вам            | to you
сказал         | he said
ведь           | particle `after all'
там            | there
потом          | then
себя           | oneself
ничего         | nothing
ей             | to her
может          | usually with `быть' as `maybe'
они            | they
тут            | here
где            | where
есть           | there is/are
надо           | got to, must
ней            | prepositional form of  ей
для            | for
мы             | we
тебя           | thee
их             | them, their
чем            | than
была           | she was
сам            | self
чтоб           | in order to
без            | without
будто          | as if
человек        | man, person, one
чего           | genitive form of `what'
раз            | once
тоже           | also
себе           | to oneself
под            | beneath
жизнь          | life
будет          | will be
ж              | short form of intensifer particle `же'
тогда          | then
кто            | who
этот           | this
говорил        | was saying
того           | genitive form of `that'
потому         | for that reason
этого          | genitive form of `this'
какой          | which
совсем         | altogether
ним            | prepositional form of `его', `они'
здесь          | here
этом           | prepositional form of `этот'
один           | one
почти          | almost
мой            | my
тем            | instrumental/dative plural of `тот', `то'
чтобы          | full form of `in order that'
нее            | her (acc.)
кажется        | it seems
сейчас         | now
были           | they were
куда           | where to
зачем          | why
сказать        | to say
всех           | all (acc., gen. preposn. plural)
никогда        | never
сегодня        | today
можно          | possible, one can
при            | by
наконец        | finally
два            | two
об             | alternative form of `о', about
другой         | another
хоть           | even
после          | after
над            | above
больше         | more
тот            | that one (masc.)
через          | across, in
эти            | these
нас            | us
про            | about
всего          | in all, only, of all
них            | prepositional form of `они' (they)
какая          | which, feminine
много          | lots
разве          | interrogative particle
сказала        | she said
три            | three
эту            | this, acc. fem. sing.
моя            | my, feminine
впрочем        | moreover, besides
хорошо         | good
свою           | ones own, acc. fem. sing.
этой           | oblique form of `эта', fem. `this'
перед          | in front of
иногда         | sometimes
лучше          | better
чуть           | a little
том            | preposn. form of `that one'
нельзя         | one must not
такой          | such a one
им             | to them
более          | more
всегда         | always
конечно        | of course
всю            | acc. fem. sing of `all'
между          | between


  | b: some paradigms
  |
  | personal pronouns
  |
  | я  меня  мне  мной  [мною]
  | ты  тебя  тебе  тобой  [тобою]
  | он  его  ему  им  [него, нему, ним]
  | она  ее  эи  ею  [нее, нэи, нею]
  | оно  его  ему  им  [него, нему, ним]
  |
  | мы  нас  нам  нами
  | вы  вас  вам  вами
  | они  их  им  ими  [них, ним, ними]
  |
  |   себя  себе  собой   [собою]
  |
  | demonstrative pronouns: этот (this), тот (that)
  |
  | этот  эта  это  эти
  | этого  эты  это  эти
  | этого  этой  этого  этих
  | этому  этой  этому  этим
  | этим  этой  этим  [этою]  этими
  | этом  этой  этом  этих
  |
  | тот  та  то  те
  | того  ту  то  те
  | того  той  того  тех
  | тому  той  тому  тем
  | тем  той  тем  [тою]  теми
  | том  той  том  тех
  |
  | determinative pronouns
  |
  | (a) весь (all)
  |
  | весь  вся  все  все
  | всего  всю  все  все
  | всего  всей  всего  всех
  | всему  всей  всему  всем
  | всем  всей  всем  [всею]  всеми
  | всем  всей  всем  всех
  |
  | (b) сам (himself etc)
  |
  | сам  сама  само  сами
  | самого саму  само  самих
  | самого самой самого  самих
  | самому самой самому  самим
  | самим  самой  самим  [самою]  самими
  | самом самой самом  самих
  |
  | stems of verbs `to be', `to have', `to do' and modal
  |
  | быть  бы  буд  быв  есть  суть
  | име
  | дел
  | мог   мож  мочь
  | уме
  | хоч  хот
  | долж
  | можн
  | нужн
  | нельзя

              L       L  xMPGd  xMPGd                           L   '/configs/_default/lang/stopwords_tr.txt  �# Turkish stopwords from LUCENE-559
# merged with the list from "Information Retrieval on Turkish Texts"
#   (http://www.users.muohio.edu/canf/papers/JASIST2008offPrint.pdf)
acaba
altmış
altı
ama
ancak
arada
aslında
ayrıca
bana
bazı
belki
ben
benden
beni
benim
beri
beş
bile
bin
bir
birçok
biri
birkaç
birkez
birşey
birşeyi
biz
bize
bizden
bizi
bizim
böyle
böylece
bu
buna
bunda
bundan
bunlar
bunları
bunların
bunu
bunun
burada
çok
çünkü
da
daha
dahi
de
defa
değil
diğer
diye
doksan
dokuz
dolayı
dolayısıyla
dört
edecek
eden
ederek
edilecek
ediliyor
edilmesi
ediyor
eğer
elli
en
etmesi
etti
ettiği
ettiğini
gibi
göre
halen
hangi
hatta
hem
henüz
hep
hepsi
her
herhangi
herkesin
hiç
hiçbir
için
iki
ile
ilgili
ise
işte
itibaren
itibariyle
kadar
karşın
katrilyon
kendi
kendilerine
kendini
kendisi
kendisine
kendisini
kez
ki
kim
kimden
kime
kimi
kimse
kırk
milyar
milyon
mu
mü
mı
nasıl
ne
neden
nedenle
nerde
nerede
nereye
niye
niçin
o
olan
olarak
oldu
olduğu
olduğunu
olduklarını
olmadı
olmadığı
olmak
olması
olmayan
olmaz
olsa
olsun
olup
olur
olursa
oluyor
on
ona
ondan
onlar
onlardan
onları
onların
onu
onun
otuz
oysa
öyle
pek
rağmen
sadece
sanki
sekiz
seksen
sen
senden
seni
senin
siz
sizden
sizi
sizin
şey
şeyden
şeyi
şeyler
şöyle
şu
şuna
şunda
şundan
şunları
şunu
tarafından
trilyon
tüm
üç
üzere
var
vardı
ve
veya
ya
yani
yapacak
yapılan
yapılması
yapıyor
yapmak
yaptı
yaptığı
yaptığını
yaptıkları
yedi
yerine
yetmiş
yine
yirmi
yoksa
yüz
zaten
              �       �  xMPG�  xMPG�                           �   '/configs/_default/lang/stopwords_ar.txt  �# This file was created by Jacques Savoy and is distributed under the BSD license.
# See http://members.unine.ch/jacques.savoy/clef/index.html.
# Also see http://www.opensource.org/licenses/bsd-license.html
# Cleaned on October 11, 2009 (not normalized, so use before normalization)
# This means that when modifying this list, you might need to add some 
# redundant entries, for example containing forms with both أ and ا
من
ومن
منها
منه
في
وفي
فيها
فيه
و
ف
ثم
او
أو
ب
بها
به
ا
أ
اى
اي
أي
أى
لا
ولا
الا
ألا
إلا
لكن
ما
وما
كما
فما
عن
مع
اذا
إذا
ان
أن
إن
انها
أنها
إنها
انه
أنه
إنه
بان
بأن
فان
فأن
وان
وأن
وإن
التى
التي
الذى
الذي
الذين
الى
الي
إلى
إلي
على
عليها
عليه
اما
أما
إما
ايضا
أيضا
كل
وكل
لم
ولم
لن
ولن
هى
هي
هو
وهى
وهي
وهو
فهى
فهي
فهو
انت
أنت
لك
لها
له
هذه
هذا
تلك
ذلك
هناك
كانت
كان
يكون
تكون
وكانت
وكان
غير
بعض
قد
نحو
بين
بينما
منذ
ضمن
حيث
الان
الآن
خلال
بعد
قبل
حتى
عند
عندما
لدى
جميع
              t       t  xMPG�  xMPG�                           t   &/configs/_default/lang/userdict_ja.txt  5#
# This is a sample user dictionary for Kuromoji (JapaneseTokenizer)
#
# Add entries to this file in order to override the statistical model in terms
# of segmentation, readings and part-of-speech tags.  Notice that entries do
# not have weights since they are always used when found.  This is by-design
# in order to maximize ease-of-use.
#
# Entries are defined using the following CSV format:
#  <text>,<token 1> ... <token n>,<reading 1> ... <reading n>,<part-of-speech tag>
#
# Notice that a single half-width space separates tokens and readings, and
# that the number tokens and readings must match exactly.
#
# Also notice that multiple entries with the same <text> is undefined.
#
# Whitespace only lines are ignored.  Comments are not allowed on entry lines.
#

# Custom segmentation for kanji compounds
日本経済新聞,日本 経済 新聞,ニホン ケイザイ シンブン,カスタム名詞
関西国際空港,関西 国際 空港,カンサイ コクサイ クウコウ,カスタム名詞

# Custom segmentation for compound katakana
トートバッグ,トート バッグ,トート バッグ,かずカナ名詞
ショルダーバッグ,ショルダー バッグ,ショルダー バッグ,かずカナ名詞

# Custom reading for former sumo wrestler
朝青龍,朝青龍,アサショウリュウ,カスタム人名
              <       <  xMPG6  xMPG6                           <   '/configs/_default/lang/stopwords_it.txt  < | From svn.tartarus.org/snowball/trunk/website/algorithms/italian/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | An Italian stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

ad             |  a (to) before vowel
al             |  a + il
allo           |  a + lo
ai             |  a + i
agli           |  a + gli
all            |  a + l'
agl            |  a + gl'
alla           |  a + la
alle           |  a + le
con            |  with
col            |  con + il
coi            |  con + i (forms collo, cogli etc are now very rare)
da             |  from
dal            |  da + il
dallo          |  da + lo
dai            |  da + i
dagli          |  da + gli
dall           |  da + l'
dagl           |  da + gll'
dalla          |  da + la
dalle          |  da + le
di             |  of
del            |  di + il
dello          |  di + lo
dei            |  di + i
degli          |  di + gli
dell           |  di + l'
degl           |  di + gl'
della          |  di + la
delle          |  di + le
in             |  in
nel            |  in + el
nello          |  in + lo
nei            |  in + i
negli          |  in + gli
nell           |  in + l'
negl           |  in + gl'
nella          |  in + la
nelle          |  in + le
su             |  on
sul            |  su + il
sullo          |  su + lo
sui            |  su + i
sugli          |  su + gli
sull           |  su + l'
sugl           |  su + gl'
sulla          |  su + la
sulle          |  su + le
per            |  through, by
tra            |  among
contro         |  against
io             |  I
tu             |  thou
lui            |  he
lei            |  she
noi            |  we
voi            |  you
loro           |  they
mio            |  my
mia            |
miei           |
mie            |
tuo            |
tua            |
tuoi           |  thy
tue            |
suo            |
sua            |
suoi           |  his, her
sue            |
nostro         |  our
nostra         |
nostri         |
nostre         |
vostro         |  your
vostra         |
vostri         |
vostre         |
mi             |  me
ti             |  thee
ci             |  us, there
vi             |  you, there
lo             |  him, the
la             |  her, the
li             |  them
le             |  them, the
gli            |  to him, the
ne             |  from there etc
il             |  the
un             |  a
uno            |  a
una            |  a
ma             |  but
ed             |  and
se             |  if
perché         |  why, because
anche          |  also
come           |  how
dov            |  where (as dov')
dove           |  where
che            |  who, that
chi            |  who
cui            |  whom
non            |  not
più            |  more
quale          |  who, that
quanto         |  how much
quanti         |
quanta         |
quante         |
quello         |  that
quelli         |
quella         |
quelle         |
questo         |  this
questi         |
questa         |
queste         |
si             |  yes
tutto          |  all
tutti          |  all

               |  single letter forms:

a              |  at
c              |  as c' for ce or ci
e              |  and
i              |  the
l              |  as l'
o              |  or

               | forms of avere, to have (not including the infinitive):

ho
hai
ha
abbiamo
avete
hanno
abbia
abbiate
abbiano
avrò
avrai
avrà
avremo
avrete
avranno
avrei
avresti
avrebbe
avremmo
avreste
avrebbero
avevo
avevi
aveva
avevamo
avevate
avevano
ebbi
avesti
ebbe
avemmo
aveste
ebbero
avessi
avesse
avessimo
avessero
avendo
avuto
avuta
avuti
avute

               | forms of essere, to be (not including the infinitive):
sono
sei
è
siamo
siete
sia
siate
siano
sarò
sarai
sarà
saremo
sarete
saranno
sarei
saresti
sarebbe
saremmo
sareste
sarebbero
ero
eri
era
eravamo
eravate
erano
fui
fosti
fu
fummo
foste
furono
fossi
fosse
fossimo
fossero
essendo

               | forms of fare, to do (not including the infinitive, fa, fat-):
faccio
fai
facciamo
fanno
faccia
facciate
facciano
farò
farai
farà
faremo
farete
faranno
farei
faresti
farebbe
faremmo
fareste
farebbero
facevo
facevi
faceva
facevamo
facevate
facevano
feci
facesti
fece
facemmo
faceste
fecero
facessi
facesse
facessimo
facessero
facendo

               | forms of stare, to be (not including the infinitive):
sto
stai
sta
stiamo
stanno
stia
stiate
stiano
starò
starai
starà
staremo
starete
staranno
starei
staresti
starebbe
staremmo
stareste
starebbero
stavo
stavi
stava
stavamo
stavate
stavano
stetti
stesti
stette
stemmo
steste
stettero
stessi
stesse
stessimo
stessero
stando
              H       H  xMPGZ  xMPGZ                           H   '/configs/_default/lang/stopwords_eu.txt  b# example set of basque stopwords
al
anitz
arabera
asko
baina
bat
batean
batek
bati
batzuei
batzuek
batzuetan
batzuk
bera
beraiek
berau
berauek
bere
berori
beroriek
beste
bezala
da
dago
dira
ditu
du
dute
edo
egin
ere
eta
eurak
ez
gainera
gu
gutxi
guzti
haiei
haiek
haietan
hainbeste
hala
han
handik
hango
hara
hari
hark
hartan
hau
hauei
hauek
hauetan
hemen
hemendik
hemengo
hi
hona
honek
honela
honetan
honi
hor
hori
horiei
horiek
horietan
horko
horra
horrek
horrela
horretan
horri
hortik
hura
izan
ni
noiz
nola
non
nondik
nongo
nor
nora
ze
zein
zen
zenbait
zenbat
zer
zergatik
ziren
zituen
zu
zuek
zuen
zuten
              �       �  xMPG�  xMPG�                           �   '/configs/_default/lang/stopwords_cz.txt  [a
s
k
o
i
u
v
z
dnes
cz
tímto
budeš
budem
byli
jseš
můj
svým
ta
tomto
tohle
tuto
tyto
jej
zda
proč
máte
tato
kam
tohoto
kdo
kteří
mi
nám
tom
tomuto
mít
nic
proto
kterou
byla
toho
protože
asi
ho
naši
napište
re
což
tím
takže
svých
její
svými
jste
aj
tu
tedy
teto
bylo
kde
ke
pravé
ji
nad
nejsou
či
pod
téma
mezi
přes
ty
pak
vám
ani
když
však
neg
jsem
tento
článku
články
aby
jsme
před
pta
jejich
byl
ještě
až
bez
také
pouze
první
vaše
která
nás
nový
tipy
pokud
může
strana
jeho
své
jiné
zprávy
nové
není
vás
jen
podle
zde
už
být
více
bude
již
než
který
by
které
co
nebo
ten
tak
má
při
od
po
jsou
jak
další
ale
si
se
ve
to
jako
za
zpět
ze
do
pro
je
na
atd
atp
jakmile
přičemž
já
on
ona
ono
oni
ony
my
vy
jí
ji
mě
mne
jemu
tomu
těm
těmu
němu
němuž
jehož
jíž
jelikož
jež
jakož
načež
              4       4  xMPG  xMPG                           4   &/configs/_default/lang/stoptags_ja.txt  AT#
# This file defines a Japanese stoptag set for JapanesePartOfSpeechStopFilter.
#
# Any token with a part-of-speech tag that exactly matches those defined in this
# file are removed from the token stream.
#
# Set your own stoptags by uncommenting the lines below.  Note that comments are
# not allowed on the same line as a stoptag.  See LUCENE-3745 for frequency lists,
# etc. that can be useful for building you own stoptag set.
#
# The entire possible tagset is provided below for convenience.
#
#####
#  noun: unclassified nouns
#名詞
#
#  noun-common: Common nouns or nouns where the sub-classification is undefined
#名詞-一般
#
#  noun-proper: Proper nouns where the sub-classification is undefined 
#名詞-固有名詞
#
#  noun-proper-misc: miscellaneous proper nouns
#名詞-固有名詞-一般
#
#  noun-proper-person: Personal names where the sub-classification is undefined
#名詞-固有名詞-人名
#
#  noun-proper-person-misc: names that cannot be divided into surname and 
#  given name; foreign names; names where the surname or given name is unknown.
#  e.g. お市の方
#名詞-固有名詞-人名-一般
#
#  noun-proper-person-surname: Mainly Japanese surnames.
#  e.g. 山田
#名詞-固有名詞-人名-姓
#
#  noun-proper-person-given_name: Mainly Japanese given names.
#  e.g. 太郎
#名詞-固有名詞-人名-名
#
#  noun-proper-organization: Names representing organizations.
#  e.g. 通産省, NHK
#名詞-固有名詞-組織
#
#  noun-proper-place: Place names where the sub-classification is undefined
#名詞-固有名詞-地域
#
#  noun-proper-place-misc: Place names excluding countries.
#  e.g. アジア, バルセロナ, 京都
#名詞-固有名詞-地域-一般
#
#  noun-proper-place-country: Country names. 
#  e.g. 日本, オーストラリア
#名詞-固有名詞-地域-国
#
#  noun-pronoun: Pronouns where the sub-classification is undefined
#名詞-代名詞
#
#  noun-pronoun-misc: miscellaneous pronouns: 
#  e.g. それ, ここ, あいつ, あなた, あちこち, いくつ, どこか, なに, みなさん, みんな, わたくし, われわれ
#名詞-代名詞-一般
#
#  noun-pronoun-contraction: Spoken language contraction made by combining a 
#  pronoun and the particle 'wa'.
#  e.g. ありゃ, こりゃ, こりゃあ, そりゃ, そりゃあ 
#名詞-代名詞-縮約
#
#  noun-adverbial: Temporal nouns such as names of days or months that behave 
#  like adverbs. Nouns that represent amount or ratios and can be used adverbially,
#  e.g. 金曜, 一月, 午後, 少量
#名詞-副詞可能
#
#  noun-verbal: Nouns that take arguments with case and can appear followed by 
#  'suru' and related verbs (する, できる, なさる, くださる)
#  e.g. インプット, 愛着, 悪化, 悪戦苦闘, 一安心, 下取り
#名詞-サ変接続
#
#  noun-adjective-base: The base form of adjectives, words that appear before な ("na")
#  e.g. 健康, 安易, 駄目, だめ
#名詞-形容動詞語幹
#
#  noun-numeric: Arabic numbers, Chinese numerals, and counters like 何 (回), 数.
#  e.g. 0, 1, 2, 何, 数, 幾
#名詞-数
#
#  noun-affix: noun affixes where the sub-classification is undefined
#名詞-非自立
#
#  noun-affix-misc: Of adnominalizers, the case-marker の ("no"), and words that 
#  attach to the base form of inflectional words, words that cannot be classified 
#  into any of the other categories below. This category includes indefinite nouns.
#  e.g. あかつき, 暁, かい, 甲斐, 気, きらい, 嫌い, くせ, 癖, こと, 事, ごと, 毎, しだい, 次第, 
#       順, せい, 所為, ついで, 序で, つもり, 積もり, 点, どころ, の, はず, 筈, はずみ, 弾み, 
#       拍子, ふう, ふり, 振り, ほう, 方, 旨, もの, 物, 者, ゆえ, 故, ゆえん, 所以, わけ, 訳,
#       わり, 割り, 割, ん-口語/, もん-口語/
#名詞-非自立-一般
#
#  noun-affix-adverbial: noun affixes that that can behave as adverbs.
#  e.g. あいだ, 間, あげく, 挙げ句, あと, 後, 余り, 以外, 以降, 以後, 以上, 以前, 一方, うえ, 
#       上, うち, 内, おり, 折り, かぎり, 限り, きり, っきり, 結果, ころ, 頃, さい, 際, 最中, さなか, 
#       最中, じたい, 自体, たび, 度, ため, 為, つど, 都度, とおり, 通り, とき, 時, ところ, 所, 
#       とたん, 途端, なか, 中, のち, 後, ばあい, 場合, 日, ぶん, 分, ほか, 他, まえ, 前, まま, 
#       儘, 侭, みぎり, 矢先
#名詞-非自立-副詞可能
#
#  noun-affix-aux: noun affixes treated as 助動詞 ("auxiliary verb") in school grammars 
#  with the stem よう(だ) ("you(da)").
#  e.g.  よう, やう, 様 (よう)
#名詞-非自立-助動詞語幹
#  
#  noun-affix-adjective-base: noun affixes that can connect to the indeclinable
#  connection form な (aux "da").
#  e.g. みたい, ふう
#名詞-非自立-形容動詞語幹
#
#  noun-special: special nouns where the sub-classification is undefined.
#名詞-特殊
#
#  noun-special-aux: The そうだ ("souda") stem form that is used for reporting news, is 
#  treated as 助動詞 ("auxiliary verb") in school grammars, and attach to the base 
#  form of inflectional words.
#  e.g. そう
#名詞-特殊-助動詞語幹
#
#  noun-suffix: noun suffixes where the sub-classification is undefined.
#名詞-接尾
#
#  noun-suffix-misc: Of the nouns or stem forms of other parts of speech that connect 
#  to ガル or タイ and can combine into compound nouns, words that cannot be classified into
#  any of the other categories below. In general, this category is more inclusive than 
#  接尾語 ("suffix") and is usually the last element in a compound noun.
#  e.g. おき, かた, 方, 甲斐 (がい), がかり, ぎみ, 気味, ぐるみ, (～した) さ, 次第, 済 (ず) み,
#       よう, (でき)っこ, 感, 観, 性, 学, 類, 面, 用
#名詞-接尾-一般
#
#  noun-suffix-person: Suffixes that form nouns and attach to person names more often
#  than other nouns.
#  e.g. 君, 様, 著
#名詞-接尾-人名
#
#  noun-suffix-place: Suffixes that form nouns and attach to place names more often 
#  than other nouns.
#  e.g. 町, 市, 県
#名詞-接尾-地域
#
#  noun-suffix-verbal: Of the suffixes that attach to nouns and form nouns, those that 
#  can appear before スル ("suru").
#  e.g. 化, 視, 分け, 入り, 落ち, 買い
#名詞-接尾-サ変接続
#
#  noun-suffix-aux: The stem form of そうだ (様態) that is used to indicate conditions, 
#  is treated as 助動詞 ("auxiliary verb") in school grammars, and attach to the 
#  conjunctive form of inflectional words.
#  e.g. そう
#名詞-接尾-助動詞語幹
#
#  noun-suffix-adjective-base: Suffixes that attach to other nouns or the conjunctive 
#  form of inflectional words and appear before the copula だ ("da").
#  e.g. 的, げ, がち
#名詞-接尾-形容動詞語幹
#
#  noun-suffix-adverbial: Suffixes that attach to other nouns and can behave as adverbs.
#  e.g. 後 (ご), 以後, 以降, 以前, 前後, 中, 末, 上, 時 (じ)
#名詞-接尾-副詞可能
#
#  noun-suffix-classifier: Suffixes that attach to numbers and form nouns. This category 
#  is more inclusive than 助数詞 ("classifier") and includes common nouns that attach 
#  to numbers.
#  e.g. 個, つ, 本, 冊, パーセント, cm, kg, カ月, か国, 区画, 時間, 時半
#名詞-接尾-助数詞
#
#  noun-suffix-special: Special suffixes that mainly attach to inflecting words.
#  e.g. (楽し) さ, (考え) 方
#名詞-接尾-特殊
#
#  noun-suffix-conjunctive: Nouns that behave like conjunctions and join two words 
#  together.
#  e.g. (日本) 対 (アメリカ), 対 (アメリカ), (3) 対 (5), (女優) 兼 (主婦)
#名詞-接続詞的
#
#  noun-verbal_aux: Nouns that attach to the conjunctive particle て ("te") and are 
#  semantically verb-like.
#  e.g. ごらん, ご覧, 御覧, 頂戴
#名詞-動詞非自立的
#
#  noun-quotation: text that cannot be segmented into words, proverbs, Chinese poetry, 
#  dialects, English, etc. Currently, the only entry for 名詞 引用文字列 ("noun quotation") 
#  is いわく ("iwaku").
#名詞-引用文字列
#
#  noun-nai_adjective: Words that appear before the auxiliary verb ない ("nai") and
#  behave like an adjective.
#  e.g. 申し訳, 仕方, とんでも, 違い
#名詞-ナイ形容詞語幹
#
#####
#  prefix: unclassified prefixes
#接頭詞
#
#  prefix-nominal: Prefixes that attach to nouns (including adjective stem forms) 
#  excluding numerical expressions.
#  e.g. お (水), 某 (氏), 同 (社), 故 (～氏), 高 (品質), お (見事), ご (立派)
#接頭詞-名詞接続
#
#  prefix-verbal: Prefixes that attach to the imperative form of a verb or a verb
#  in conjunctive form followed by なる/なさる/くださる.
#  e.g. お (読みなさい), お (座り)
#接頭詞-動詞接続
#
#  prefix-adjectival: Prefixes that attach to adjectives.
#  e.g. お (寒いですねえ), バカ (でかい)
#接頭詞-形容詞接続
#
#  prefix-numerical: Prefixes that attach to numerical expressions.
#  e.g. 約, およそ, 毎時
#接頭詞-数接続
#
#####
#  verb: unclassified verbs
#動詞
#
#  verb-main:
#動詞-自立
#
#  verb-auxiliary:
#動詞-非自立
#
#  verb-suffix:
#動詞-接尾
#
#####
#  adjective: unclassified adjectives
#形容詞
#
#  adjective-main:
#形容詞-自立
#
#  adjective-auxiliary:
#形容詞-非自立
#
#  adjective-suffix:
#形容詞-接尾
#
#####
#  adverb: unclassified adverbs
#副詞
#
#  adverb-misc: Words that can be segmented into one unit and where adnominal 
#  modification is not possible.
#  e.g. あいかわらず, 多分
#副詞-一般
#
#  adverb-particle_conjunction: Adverbs that can be followed by の, は, に, 
#  な, する, だ, etc.
#  e.g. こんなに, そんなに, あんなに, なにか, なんでも
#副詞-助詞類接続
#
#####
#  adnominal: Words that only have noun-modifying forms.
#  e.g. この, その, あの, どの, いわゆる, なんらかの, 何らかの, いろんな, こういう, そういう, ああいう, 
#       どういう, こんな, そんな, あんな, どんな, 大きな, 小さな, おかしな, ほんの, たいした, 
#       「(, も) さる (ことながら)」, 微々たる, 堂々たる, 単なる, いかなる, 我が」「同じ, 亡き
#連体詞
#
#####
#  conjunction: Conjunctions that can occur independently.
#  e.g. が, けれども, そして, じゃあ, それどころか
接続詞
#
#####
#  particle: unclassified particles.
助詞
#
#  particle-case: case particles where the subclassification is undefined.
助詞-格助詞
#
#  particle-case-misc: Case particles.
#  e.g. から, が, で, と, に, へ, より, を, の, にて
助詞-格助詞-一般
#
#  particle-case-quote: the "to" that appears after nouns, a person’s speech, 
#  quotation marks, expressions of decisions from a meeting, reasons, judgements,
#  conjectures, etc.
#  e.g. ( だ) と (述べた.), ( である) と (して執行猶予...)
助詞-格助詞-引用
#
#  particle-case-compound: Compounds of particles and verbs that mainly behave 
#  like case particles.
#  e.g. という, といった, とかいう, として, とともに, と共に, でもって, にあたって, に当たって, に当って,
#       にあたり, に当たり, に当り, に当たる, にあたる, において, に於いて,に於て, における, に於ける, 
#       にかけ, にかけて, にかんし, に関し, にかんして, に関して, にかんする, に関する, に際し, 
#       に際して, にしたがい, に従い, に従う, にしたがって, に従って, にたいし, に対し, にたいして, 
#       に対して, にたいする, に対する, について, につき, につけ, につけて, につれ, につれて, にとって,
#       にとり, にまつわる, によって, に依って, に因って, により, に依り, に因り, による, に依る, に因る, 
#       にわたって, にわたる, をもって, を以って, を通じ, を通じて, を通して, をめぐって, をめぐり, をめぐる,
#       って-口語/, ちゅう-関西弁「という」/, (何) ていう (人)-口語/, っていう-口語/, といふ, とかいふ
助詞-格助詞-連語
#
#  particle-conjunctive:
#  e.g. から, からには, が, けれど, けれども, けど, し, つつ, て, で, と, ところが, どころか, とも, ども, 
#       ながら, なり, ので, のに, ば, ものの, や ( した), やいなや, (ころん) じゃ(いけない)-口語/, 
#       (行っ) ちゃ(いけない)-口語/, (言っ) たって (しかたがない)-口語/, (それがなく)ったって (平気)-口語/
助詞-接続助詞
#
#  particle-dependency:
#  e.g. こそ, さえ, しか, すら, は, も, ぞ
助詞-係助詞
#
#  particle-adverbial:
#  e.g. がてら, かも, くらい, 位, ぐらい, しも, (学校) じゃ(これが流行っている)-口語/, 
#       (それ)じゃあ (よくない)-口語/, ずつ, (私) なぞ, など, (私) なり (に), (先生) なんか (大嫌い)-口語/,
#       (私) なんぞ, (先生) なんて (大嫌い)-口語/, のみ, だけ, (私) だって-口語/, だに, 
#       (彼)ったら-口語/, (お茶) でも (いかが), 等 (とう), (今後) とも, ばかり, ばっか-口語/, ばっかり-口語/,
#       ほど, 程, まで, 迄, (誰) も (が)([助詞-格助詞] および [助詞-係助詞] の前に位置する「も」)
助詞-副助詞
#
#  particle-interjective: particles with interjective grammatical roles.
#  e.g. (松島) や
助詞-間投助詞
#
#  particle-coordinate:
#  e.g. と, たり, だの, だり, とか, なり, や, やら
助詞-並立助詞
#
#  particle-final:
#  e.g. かい, かしら, さ, ぜ, (だ)っけ-口語/, (とまってる) で-方言/, な, ナ, なあ-口語/, ぞ, ね, ネ, 
#       ねぇ-口語/, ねえ-口語/, ねん-方言/, の, のう-口語/, や, よ, ヨ, よぉ-口語/, わ, わい-口語/
助詞-終助詞
#
#  particle-adverbial/conjunctive/final: The particle "ka" when unknown whether it is 
#  adverbial, conjunctive, or sentence final. For example:
#       (a) 「A か B か」. Ex:「(国内で運用する) か,(海外で運用する) か (.)」
#       (b) Inside an adverb phrase. Ex:「(幸いという) か (, 死者はいなかった.)」
#           「(祈りが届いたせい) か (, 試験に合格した.)」
#       (c) 「かのように」. Ex:「(何もなかった) か (のように振る舞った.)」
#  e.g. か
助詞-副助詞／並立助詞／終助詞
#
#  particle-adnominalizer: The "no" that attaches to nouns and modifies 
#  non-inflectional words.
助詞-連体化
#
#  particle-adnominalizer: The "ni" and "to" that appear following nouns and adverbs 
#  that are giongo, giseigo, or gitaigo.
#  e.g. に, と
助詞-副詞化
#
#  particle-special: A particle that does not fit into one of the above classifications. 
#  This includes particles that are used in Tanka, Haiku, and other poetry.
#  e.g. かな, けむ, ( しただろう) に, (あんた) にゃ(わからん), (俺) ん (家)
助詞-特殊
#
#####
#  auxiliary-verb:
助動詞
#
#####
#  interjection: Greetings and other exclamations.
#  e.g. おはよう, おはようございます, こんにちは, こんばんは, ありがとう, どうもありがとう, ありがとうございます, 
#       いただきます, ごちそうさま, さよなら, さようなら, はい, いいえ, ごめん, ごめんなさい
#感動詞
#
#####
#  symbol: unclassified Symbols.
記号
#
#  symbol-misc: A general symbol not in one of the categories below.
#  e.g. [○◎@$〒→+]
記号-一般
#
#  symbol-comma: Commas
#  e.g. [,、]
記号-読点
#
#  symbol-period: Periods and full stops.
#  e.g. [.．。]
記号-句点
#
#  symbol-space: Full-width whitespace.
記号-空白
#
#  symbol-open_bracket:
#  e.g. [({‘“『【]
記号-括弧開
#
#  symbol-close_bracket:
#  e.g. [)}’”』」】]
記号-括弧閉
#
#  symbol-alphabetic:
#記号-アルファベット
#
#####
#  other: unclassified other
#その他
#
#  other-interjection: Words that are hard to classify as noun-suffixes or 
#  sentence-final particles.
#  e.g. (だ)ァ
その他-間投
#
#####
#  filler: Aizuchi that occurs during a conversation or sounds inserted as filler.
#  e.g. あの, うんと, えと
フィラー
#
#####
#  non-verbal: non-verbal sound.
非言語音
#
#####
#  fragment:
#語断片
#
#####
#  unknown: unknown part of speech.
#未知語
#
##### End of file
              0       0  xMPG  xMPG                           0   */configs/_default/lang/contractions_fr.txt   �# Set of French contractions for ElisionFilter
# TODO: load this as a resource from the analyzer and sync it in build.xml
l
m
t
qu
n
s
j
d
c
jusqu
quoiqu
lorsqu
puisqu
              h       h  xMPG�  xMPG�                           h   '/configs/_default/lang/stopwords_de.txt  � | From svn.tartarus.org/snowball/trunk/website/algorithms/german/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A German stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

 | The number of forms in this list is reduced significantly by passing it
 | through the German stemmer.


aber           |  but

alle           |  all
allem
allen
aller
alles

als            |  than, as
also           |  so
am             |  an + dem
an             |  at

ander          |  other
andere
anderem
anderen
anderer
anderes
anderm
andern
anderr
anders

auch           |  also
auf            |  on
aus            |  out of
bei            |  by
bin            |  am
bis            |  until
bist           |  art
da             |  there
damit          |  with it
dann           |  then

der            |  the
den
des
dem
die
das

daß            |  that

derselbe       |  the same
derselben
denselben
desselben
demselben
dieselbe
dieselben
dasselbe

dazu           |  to that

dein           |  thy
deine
deinem
deinen
deiner
deines

denn           |  because

derer          |  of those
dessen         |  of him

dich           |  thee
dir            |  to thee
du             |  thou

dies           |  this
diese
diesem
diesen
dieser
dieses


doch           |  (several meanings)
dort           |  (over) there


durch          |  through

ein            |  a
eine
einem
einen
einer
eines

einig          |  some
einige
einigem
einigen
einiger
einiges

einmal         |  once

er             |  he
ihn            |  him
ihm            |  to him

es             |  it
etwas          |  something

euer           |  your
eure
eurem
euren
eurer
eures

für            |  for
gegen          |  towards
gewesen        |  p.p. of sein
hab            |  have
habe           |  have
haben          |  have
hat            |  has
hatte          |  had
hatten         |  had
hier           |  here
hin            |  there
hinter         |  behind

ich            |  I
mich           |  me
mir            |  to me


ihr            |  you, to her
ihre
ihrem
ihren
ihrer
ihres
euch           |  to you

im             |  in + dem
in             |  in
indem          |  while
ins            |  in + das
ist            |  is

jede           |  each, every
jedem
jeden
jeder
jedes

jene           |  that
jenem
jenen
jener
jenes

jetzt          |  now
kann           |  can

kein           |  no
keine
keinem
keinen
keiner
keines

können         |  can
könnte         |  could
machen         |  do
man            |  one

manche         |  some, many a
manchem
manchen
mancher
manches

mein           |  my
meine
meinem
meinen
meiner
meines

mit            |  with
muss           |  must
musste         |  had to
nach           |  to(wards)
nicht          |  not
nichts         |  nothing
noch           |  still, yet
nun            |  now
nur            |  only
ob             |  whether
oder           |  or
ohne           |  without
sehr           |  very

sein           |  his
seine
seinem
seinen
seiner
seines

selbst         |  self
sich           |  herself

sie            |  they, she
ihnen          |  to them

sind           |  are
so             |  so

solche         |  such
solchem
solchen
solcher
solches

soll           |  shall
sollte         |  should
sondern        |  but
sonst          |  else
über           |  over
um             |  about, around
und            |  and

uns            |  us
unse
unsem
unsen
unser
unses

unter          |  under
viel           |  much
vom            |  von + dem
von            |  from
vor            |  before
während        |  while
war            |  was
waren          |  were
warst          |  wast
was            |  what
weg            |  away, off
weil           |  because
weiter         |  further

welche         |  which
welchem
welchen
welcher
welches

wenn           |  when
werde          |  will
werden         |  will
wie            |  how
wieder         |  again
will           |  want
wir            |  we
wird           |  will
wirst          |  willst
wo             |  where
wollen         |  want
wollte         |  wanted
würde          |  would
würden         |  would
zu             |  to
zum            |  zu + dem
zur            |  zu + der
zwar           |  indeed
zwischen       |  between

              (       (  xMPG  xMPG                           (   '/configs/_default/lang/stopwords_fa.txt  �# This file was created by Jacques Savoy and is distributed under the BSD license.
# See http://members.unine.ch/jacques.savoy/clef/index.html.
# Also see http://www.opensource.org/licenses/bsd-license.html
# Note: by default this file is used after normalization, so when adding entries
# to this file, use the arabic 'ي' instead of 'ی'
انان
نداشته
سراسر
خياه
ايشان
وي
تاكنون
بيشتري
دوم
پس
ناشي
وگو
يا
داشتند
سپس
هنگام
هرگز
پنج
نشان
امسال
ديگر
گروهي
شدند
چطور
ده
و
دو
نخستين
ولي
چرا
چه
وسط
ه
كدام
قابل
يك
رفت
هفت
همچنين
در
هزار
بله
بلي
شايد
اما
شناسي
گرفته
دهد
داشته
دانست
داشتن
خواهيم
ميليارد
وقتيكه
امد
خواهد
جز
اورده
شده
بلكه
خدمات
شدن
برخي
نبود
بسياري
جلوگيري
حق
كردند
نوعي
بعري
نكرده
نظير
نبايد
بوده
بودن
داد
اورد
هست
جايي
شود
دنبال
داده
بايد
سابق
هيچ
همان
انجا
كمتر
كجاست
گردد
كسي
تر
مردم
تان
دادن
بودند
سري
جدا
ندارند
مگر
يكديگر
دارد
دهند
بنابراين
هنگامي
سمت
جا
انچه
خود
دادند
زياد
دارند
اثر
بدون
بهترين
بيشتر
البته
به
براساس
بيرون
كرد
بعضي
گرفت
توي
اي
ميليون
او
جريان
تول
بر
مانند
برابر
باشيم
مدتي
گويند
اكنون
تا
تنها
جديد
چند
بي
نشده
كردن
كردم
گويد
كرده
كنيم
نمي
نزد
روي
قصد
فقط
بالاي
ديگران
اين
ديروز
توسط
سوم
ايم
دانند
سوي
استفاده
شما
كنار
داريم
ساخته
طور
امده
رفته
نخست
بيست
نزديك
طي
كنيد
از
انها
تمامي
داشت
يكي
طريق
اش
چيست
روب
نمايد
گفت
چندين
چيزي
تواند
ام
ايا
با
ان
ايد
ترين
اينكه
ديگري
راه
هايي
بروز
همچنان
پاعين
كس
حدود
مختلف
مقابل
چيز
گيرد
ندارد
ضد
همچون
سازي
شان
مورد
باره
مرسي
خويش
برخوردار
چون
خارج
شش
هنوز
تحت
ضمن
هستيم
گفته
فكر
بسيار
پيش
براي
روزهاي
انكه
نخواهد
بالا
كل
وقتي
كي
چنين
كه
گيري
نيست
است
كجا
كند
نيز
يابد
بندي
حتي
توانند
عقب
خواست
كنند
بين
تمام
همه
ما
باشند
مثل
شد
اري
باشد
اره
طبق
بعد
اگر
صورت
غير
جاي
بيش
ريزي
اند
زيرا
چگونه
بار
لطفا
مي
درباره
من
ديده
همين
گذاري
برداري
علت
گذاشته
هم
فوق
نه
ها
شوند
اباد
همواره
هر
اول
خواهند
چهار
نام
امروز
مان
هاي
قبل
كنم
سعي
تازه
را
هستند
زير
جلوي
عنوان
بود
              x       x  xMPG�  xMPG�                           x   */configs/_default/lang/contractions_ga.txt   # Set of Irish contractions for ElisionFilter
# TODO: load this as a resource from the analyzer and sync it in build.xml
d
m
b
              `       `  xMPG�  xMPG�                           `   '/configs/_default/lang/stopwords_ca.txt  # Catalan stopwords from http://github.com/vcl/cue.language (Apache 2 Licensed)
a
abans
ací
ah
així
això
al
als
aleshores
algun
alguna
algunes
alguns
alhora
allà
allí
allò
altra
altre
altres
amb
ambdós
ambdues
apa
aquell
aquella
aquelles
aquells
aquest
aquesta
aquestes
aquests
aquí
baix
cada
cadascú
cadascuna
cadascunes
cadascuns
com
contra
d'un
d'una
d'unes
d'uns
dalt
de
del
dels
des
després
dins
dintre
donat
doncs
durant
e
eh
el
els
em
en
encara
ens
entre
érem
eren
éreu
es
és
esta
està
estàvem
estaven
estàveu
esteu
et
etc
ets
fins
fora
gairebé
ha
han
has
havia
he
hem
heu
hi 
ho
i
igual
iguals
ja
l'hi
la
les
li
li'n
llavors
m'he
ma
mal
malgrat
mateix
mateixa
mateixes
mateixos
me
mentre
més
meu
meus
meva
meves
molt
molta
moltes
molts
mon
mons
n'he
n'hi
ne
ni
no
nogensmenys
només
nosaltres
nostra
nostre
nostres
o
oh
oi
on
pas
pel
pels
per
però
perquè
poc 
poca
pocs
poques
potser
propi
qual
quals
quan
quant 
que
què
quelcom
qui
quin
quina
quines
quins
s'ha
s'han
sa
semblant
semblants
ses
seu 
seus
seva
seva
seves
si
sobre
sobretot
sóc
solament
sols
son 
són
sons 
sota
sou
t'ha
t'han
t'he
ta
tal
també
tampoc
tan
tant
tanta
tantes
teu
teus
teva
teves
ton
tons
tot
tota
totes
tots
un
una
unes
uns
us
va
vaig
vam
van
vas
veu
vosaltres
vostra
vostre
vostres
              �       �  xMPH:  xMPH:                           �   '/configs/_default/lang/stopwords_nl.txt   | From svn.tartarus.org/snowball/trunk/website/algorithms/dutch/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Dutch stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

 | This is a ranked list (commonest to rarest) of stopwords derived from
 | a large sample of Dutch text.

 | Dutch stop words frequently exhibit homonym clashes. These are indicated
 | clearly below.

de             |  the
en             |  and
van            |  of, from
ik             |  I, the ego
te             |  (1) chez, at etc, (2) to, (3) too
dat            |  that, which
die            |  that, those, who, which
in             |  in, inside
een            |  a, an, one
hij            |  he
het            |  the, it
niet           |  not, nothing, naught
zijn           |  (1) to be, being, (2) his, one's, its
is             |  is
was            |  (1) was, past tense of all persons sing. of 'zijn' (to be) (2) wax, (3) the washing, (4) rise of river
op             |  on, upon, at, in, up, used up
aan            |  on, upon, to (as dative)
met            |  with, by
als            |  like, such as, when
voor           |  (1) before, in front of, (2) furrow
had            |  had, past tense all persons sing. of 'hebben' (have)
er             |  there
maar           |  but, only
om             |  round, about, for etc
hem            |  him
dan            |  then
zou            |  should/would, past tense all persons sing. of 'zullen'
of             |  or, whether, if
wat            |  what, something, anything
mijn           |  possessive and noun 'mine'
men            |  people, 'one'
dit            |  this
zo             |  so, thus, in this way
door           |  through by
over           |  over, across
ze             |  she, her, they, them
zich           |  oneself
bij            |  (1) a bee, (2) by, near, at
ook            |  also, too
tot            |  till, until
je             |  you
mij            |  me
uit            |  out of, from
der            |  Old Dutch form of 'van der' still found in surnames
daar           |  (1) there, (2) because
haar           |  (1) her, their, them, (2) hair
naar           |  (1) unpleasant, unwell etc, (2) towards, (3) as
heb            |  present first person sing. of 'to have'
hoe            |  how, why
heeft          |  present third person sing. of 'to have'
hebben         |  'to have' and various parts thereof
deze           |  this
u              |  you
want           |  (1) for, (2) mitten, (3) rigging
nog            |  yet, still
zal            |  'shall', first and third person sing. of verb 'zullen' (will)
me             |  me
zij            |  she, they
nu             |  now
ge             |  'thou', still used in Belgium and south Netherlands
geen           |  none
omdat          |  because
iets           |  something, somewhat
worden         |  to become, grow, get
toch           |  yet, still
al             |  all, every, each
waren          |  (1) 'were' (2) to wander, (3) wares, (3)
veel           |  much, many
meer           |  (1) more, (2) lake
doen           |  to do, to make
toen           |  then, when
moet           |  noun 'spot/mote' and present form of 'to must'
ben            |  (1) am, (2) 'are' in interrogative second person singular of 'to be'
zonder         |  without
kan            |  noun 'can' and present form of 'to be able'
hun            |  their, them
dus            |  so, consequently
alles          |  all, everything, anything
onder          |  under, beneath
ja             |  yes, of course
eens           |  once, one day
hier           |  here
wie            |  who
werd           |  imperfect third person sing. of 'become'
altijd         |  always
doch           |  yet, but etc
wordt          |  present third person sing. of 'become'
wezen          |  (1) to be, (2) 'been' as in 'been fishing', (3) orphans
kunnen         |  to be able
ons            |  us/our
zelf           |  self
tegen          |  against, towards, at
na             |  after, near
reeds          |  already
wil            |  (1) present tense of 'want', (2) 'will', noun, (3) fender
kon            |  could; past tense of 'to be able'
niets          |  nothing
uw             |  your
iemand         |  somebody
geweest        |  been; past participle of 'be'
andere         |  other
              �       �  xMPH.  xMPH.                           �   '/configs/_default/lang/stopwords_bg.txt  G# This file was created by Jacques Savoy and is distributed under the BSD license.
# See http://members.unine.ch/jacques.savoy/clef/index.html.
# Also see http://www.opensource.org/licenses/bsd-license.html
а
аз
ако
ала
бе
без
беше
би
бил
била
били
било
близо
бъдат
бъде
бяха
в
вас
ваш
ваша
вероятно
вече
взема
ви
вие
винаги
все
всеки
всички
всичко
всяка
във
въпреки
върху
г
ги
главно
го
д
да
дали
до
докато
докога
дори
досега
доста
е
едва
един
ето
за
зад
заедно
заради
засега
затова
защо
защото
и
из
или
им
има
имат
иска
й
каза
как
каква
какво
както
какъв
като
кога
когато
което
които
кой
който
колко
която
къде
където
към
ли
м
ме
между
мен
ми
мнозина
мога
могат
може
моля
момента
му
н
на
над
назад
най
направи
напред
например
нас
не
него
нея
ни
ние
никой
нито
но
някои
някой
няма
обаче
около
освен
особено
от
отгоре
отново
още
пак
по
повече
повечето
под
поне
поради
после
почти
прави
пред
преди
през
при
пък
първо
с
са
само
се
сега
си
скоро
след
сме
според
сред
срещу
сте
съм
със
също
т
тази
така
такива
такъв
там
твой
те
тези
ти
тн
то
това
тогава
този
той
толкова
точно
трябва
тук
тъй
тя
тях
у
харесва
ч
че
често
чрез
ще
щом
я
              l       l  xMPG�  xMPG�                           l   '/configs/_default/lang/stopwords_lv.txt  �# Set of Latvian stopwords from A Stemming Algorithm for Latvian, Karlis Kreslins
# the original list of over 800 forms was refined: 
#   pronouns, adverbs, interjections were removed
# 
# prepositions
aiz
ap
ar
apakš
ārpus
augšpus
bez
caur
dēļ
gar
iekš
iz
kopš
labad
lejpus
līdz
no
otrpus
pa
par
pār
pēc
pie
pirms
pret
priekš
starp
šaipus
uz
viņpus
virs
virspus
zem
apakšpus
# Conjunctions
un
bet
jo
ja
ka
lai
tomēr
tikko
turpretī
arī
kaut
gan
tādēļ
tā
ne
tikvien
vien
kā
ir
te
vai
kamēr
# Particles
ar
diezin
droši
diemžēl
nebūt
ik
it
taču
nu
pat
tiklab
iekšpus
nedz
tik
nevis
turpretim
jeb
iekam
iekām
iekāms
kolīdz
līdzko
tiklīdz
jebšu
tālab
tāpēc
nekā
itin
jā
jau
jel
nē
nezin
tad
tikai
vis
tak
iekams
vien
# modal verbs
būt  
biju 
biji
bija
bijām
bijāt
esmu
esi
esam
esat 
būšu     
būsi
būs
būsim
būsiet
tikt
tiku
tiki
tika
tikām
tikāt
tieku
tiec
tiek
tiekam
tiekat
tikšu
tiks
tiksim
tiksiet
tapt
tapi
tapāt
topat
tapšu
tapsi
taps
tapsim
tapsiet
kļūt
kļuvu
kļuvi
kļuva
kļuvām
kļuvāt
kļūstu
kļūsti
kļūst
kļūstam
kļūstat
kļūšu
kļūsi
kļūs
kļūsim
kļūsiet
# verbs
varēt
varēju
varējām
varēšu
varēsim
var
varēji
varējāt
varēsi
varēsiet
varat
varēja
varēs
              8       8  xMPG&  xMPG&                           8   '/configs/_default/lang/stopwords_es.txt  L | From svn.tartarus.org/snowball/trunk/website/algorithms/spanish/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Spanish stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.


 | The following is a ranked list (commonest to rarest) of stopwords
 | deriving from a large sample of text.

 | Extra words have been added at the end.

de             |  from, of
la             |  the, her
que            |  who, that
el             |  the
en             |  in
y              |  and
a              |  to
los            |  the, them
del            |  de + el
se             |  himself, from him etc
las            |  the, them
por            |  for, by, etc
un             |  a
para           |  for
con            |  with
no             |  no
una            |  a
su             |  his, her
al             |  a + el
  | es         from SER
lo             |  him
como           |  how
más            |  more
pero           |  pero
sus            |  su plural
le             |  to him, her
ya             |  already
o              |  or
  | fue        from SER
este           |  this
  | ha         from HABER
sí             |  himself etc
porque         |  because
esta           |  this
  | son        from SER
entre          |  between
  | está     from ESTAR
cuando         |  when
muy            |  very
sin            |  without
sobre          |  on
  | ser        from SER
  | tiene      from TENER
también        |  also
me             |  me
hasta          |  until
hay            |  there is/are
donde          |  where
  | han        from HABER
quien          |  whom, that
  | están      from ESTAR
  | estado     from ESTAR
desde          |  from
todo           |  all
nos            |  us
durante        |  during
  | estados    from ESTAR
todos          |  all
uno            |  a
les            |  to them
ni             |  nor
contra         |  against
otros          |  other
  | fueron     from SER
ese            |  that
eso            |  that
  | había      from HABER
ante           |  before
ellos          |  they
e              |  and (variant of y)
esto           |  this
mí             |  me
antes          |  before
algunos        |  some
qué            |  what?
unos           |  a
yo             |  I
otro           |  other
otras          |  other
otra           |  other
él             |  he
tanto          |  so much, many
esa            |  that
estos          |  these
mucho          |  much, many
quienes        |  who
nada           |  nothing
muchos         |  many
cual           |  who
  | sea        from SER
poco           |  few
ella           |  she
estar          |  to be
  | haber      from HABER
estas          |  these
  | estaba     from ESTAR
  | estamos    from ESTAR
algunas        |  some
algo           |  something
nosotros       |  we

      | other forms

mi             |  me
mis            |  mi plural
tú             |  thou
te             |  thee
ti             |  thee
tu             |  thy
tus            |  tu plural
ellas          |  they
nosotras       |  we
vosotros       |  you
vosotras       |  you
os             |  you
mío            |  mine
mía            |
míos           |
mías           |
tuyo           |  thine
tuya           |
tuyos          |
tuyas          |
suyo           |  his, hers, theirs
suya           |
suyos          |
suyas          |
nuestro        |  ours
nuestra        |
nuestros       |
nuestras       |
vuestro        |  yours
vuestra        |
vuestros       |
vuestras       |
esos           |  those
esas           |  those

               | forms of estar, to be (not including the infinitive):
estoy
estás
está
estamos
estáis
están
esté
estés
estemos
estéis
estén
estaré
estarás
estará
estaremos
estaréis
estarán
estaría
estarías
estaríamos
estaríais
estarían
estaba
estabas
estábamos
estabais
estaban
estuve
estuviste
estuvo
estuvimos
estuvisteis
estuvieron
estuviera
estuvieras
estuviéramos
estuvierais
estuvieran
estuviese
estuvieses
estuviésemos
estuvieseis
estuviesen
estando
estado
estada
estados
estadas
estad

               | forms of haber, to have (not including the infinitive):
he
has
ha
hemos
habéis
han
haya
hayas
hayamos
hayáis
hayan
habré
habrás
habrá
habremos
habréis
habrán
habría
habrías
habríamos
habríais
habrían
había
habías
habíamos
habíais
habían
hube
hubiste
hubo
hubimos
hubisteis
hubieron
hubiera
hubieras
hubiéramos
hubierais
hubieran
hubiese
hubieses
hubiésemos
hubieseis
hubiesen
habiendo
habido
habida
habidos
habidas

               | forms of ser, to be (not including the infinitive):
soy
eres
es
somos
sois
son
sea
seas
seamos
seáis
sean
seré
serás
será
seremos
seréis
serán
sería
serías
seríamos
seríais
serían
era
eras
éramos
erais
eran
fui
fuiste
fue
fuimos
fuisteis
fueron
fuera
fueras
fuéramos
fuerais
fueran
fuese
fueses
fuésemos
fueseis
fuesen
siendo
sido
  |  sed also means 'thirst'

               | forms of tener, to have (not including the infinitive):
tengo
tienes
tiene
tenemos
tenéis
tienen
tenga
tengas
tengamos
tengáis
tengan
tendré
tendrás
tendrá
tendremos
tendréis
tendrán
tendría
tendrías
tendríamos
tendríais
tendrían
tenía
tenías
teníamos
teníais
tenían
tuve
tuviste
tuvo
tuvimos
tuvisteis
tuvieron
tuviera
tuvieras
tuviéramos
tuvierais
tuvieran
tuviese
tuvieses
tuviésemos
tuvieseis
tuviesen
teniendo
tenido
tenida
tenidos
tenidas
tened

              �       �  xMPH  xMPH                           �   '/configs/_default/lang/stopwords_en.txt  F# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# a couple of test stopwords to test that the words are really being
# configured from this file:
stopworda
stopwordb

# Standard english stop words taken from Lucene's StopAnalyzer
a
an
and
are
as
at
be
but
by
for
if
in
into
is
it
no
not
of
on
or
such
that
the
their
then
there
these
they
this
to
was
will
with
              �       �  xMPHX  xMPHX                           �   '/configs/_default/lang/stopwords_th.txt  8# Thai stopwords from:
# "Opinion Detection in Thai Political News Columns
# Based on Subjectivity Analysis"
# Khampol Sukhum, Supot Nitsuwat, and Choochart Haruechaiyasak
ไว้
ไม่
ไป
ได้
ให้
ใน
โดย
แห่ง
แล้ว
และ
แรก
แบบ
แต่
เอง
เห็น
เลย
เริ่ม
เรา
เมื่อ
เพื่อ
เพราะ
เป็นการ
เป็น
เปิดเผย
เปิด
เนื่องจาก
เดียวกัน
เดียว
เช่น
เฉพาะ
เคย
เข้า
เขา
อีก
อาจ
อะไร
ออก
อย่าง
อยู่
อยาก
หาก
หลาย
หลังจาก
หลัง
หรือ
หนึ่ง
ส่วน
ส่ง
สุด
สําหรับ
ว่า
วัน
ลง
ร่วม
ราย
รับ
ระหว่าง
รวม
ยัง
มี
มาก
มา
พร้อม
พบ
ผ่าน
ผล
บาง
น่า
นี้
นํา
นั้น
นัก
นอกจาก
ทุก
ที่สุด
ที่
ทําให้
ทํา
ทาง
ทั้งนี้
ทั้ง
ถ้า
ถูก
ถึง
ต้อง
ต่างๆ
ต่าง
ต่อ
ตาม
ตั้งแต่
ตั้ง
ด้าน
ด้วย
ดัง
ซึ่ง
ช่วง
จึง
จาก
จัด
จะ
คือ
ความ
ครั้ง
คง
ขึ้น
ของ
ขอ
ขณะ
ก่อน
ก็
การ
กับ
กัน
กว่า
กล่าว
              �       �  xMPH%  xMPH%                           �   '/configs/_default/lang/stopwords_ro.txt  # This file was created by Jacques Savoy and is distributed under the BSD license.
# See http://members.unine.ch/jacques.savoy/clef/index.html.
# Also see http://www.opensource.org/licenses/bsd-license.html
acea
aceasta
această
aceea
acei
aceia
acel
acela
acele
acelea
acest
acesta
aceste
acestea
aceşti
aceştia
acolo
acum
ai
aia
aibă
aici
al
ăla
ale
alea
ălea
altceva
altcineva
am
ar
are
aş
aşadar
asemenea
asta
ăsta
astăzi
astea
ăstea
ăştia
asupra
aţi
au
avea
avem
aveţi
azi
bine
bucur
bună
ca
că
căci
când
care
cărei
căror
cărui
cât
câte
câţi
către
câtva
ce
cel
ceva
chiar
cînd
cine
cineva
cît
cîte
cîţi
cîtva
contra
cu
cum
cumva
curând
curînd
da
dă
dacă
dar
datorită
de
deci
deja
deoarece
departe
deşi
din
dinaintea
dintr
dintre
drept
după
ea
ei
el
ele
eram
este
eşti
eu
face
fără
fi
fie
fiecare
fii
fim
fiţi
iar
ieri
îi
îl
îmi
împotriva
în 
înainte
înaintea
încât
încît
încotro
între
întrucât
întrucît
îţi
la
lângă
le
li
lîngă
lor
lui
mă
mâine
mea
mei
mele
mereu
meu
mi
mine
mult
multă
mulţi
ne
nicăieri
nici
nimeni
nişte
noastră
noastre
noi
noştri
nostru
nu
ori
oricând
oricare
oricât
orice
oricînd
oricine
oricît
oricum
oriunde
până
pe
pentru
peste
pînă
poate
pot
prea
prima
primul
prin
printr
sa
să
săi
sale
sau
său
se
şi
sînt
sîntem
sînteţi
spre
sub
sunt
suntem
sunteţi
ta
tăi
tale
tău
te
ţi
ţie
tine
toată
toate
tot
toţi
totuşi
tu
un
una
unde
undeva
unei
unele
uneori
unor
vă
vi
voastră
voastre
voi
voştri
vostru
vouă
vreo
vreun
              �       �  xMPHO  xMPHO                           �   '/configs/_default/lang/stopwords_fr.txt  w | From svn.tartarus.org/snowball/trunk/website/algorithms/french/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A French stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

au             |  a + le
aux            |  a + les
avec           |  with
ce             |  this
ces            |  these
dans           |  with
de             |  of
des            |  de + les
du             |  de + le
elle           |  she
en             |  `of them' etc
et             |  and
eux            |  them
il             |  he
je             |  I
la             |  the
le             |  the
leur           |  their
lui            |  him
ma             |  my (fem)
mais           |  but
me             |  me
même           |  same; as in moi-même (myself) etc
mes            |  me (pl)
moi            |  me
mon            |  my (masc)
ne             |  not
nos            |  our (pl)
notre          |  our
nous           |  we
on             |  one
ou             |  where
par            |  by
pas            |  not
pour           |  for
qu             |  que before vowel
que            |  that
qui            |  who
sa             |  his, her (fem)
se             |  oneself
ses            |  his (pl)
son            |  his, her (masc)
sur            |  on
ta             |  thy (fem)
te             |  thee
tes            |  thy (pl)
toi            |  thee
ton            |  thy (masc)
tu             |  thou
un             |  a
une            |  a
vos            |  your (pl)
votre          |  your
vous           |  you

               |  single letter forms

c              |  c'
d              |  d'
j              |  j'
l              |  l'
à              |  to, at
m              |  m'
n              |  n'
s              |  s'
t              |  t'
y              |  there

               | forms of être (not including the infinitive):
été
étée
étées
étés
étant
suis
es
est
sommes
êtes
sont
serai
seras
sera
serons
serez
seront
serais
serait
serions
seriez
seraient
étais
était
étions
étiez
étaient
fus
fut
fûmes
fûtes
furent
sois
soit
soyons
soyez
soient
fusse
fusses
fût
fussions
fussiez
fussent

               | forms of avoir (not including the infinitive):
ayant
eu
eue
eues
eus
ai
as
avons
avez
ont
aurai
auras
aura
aurons
aurez
auront
aurais
aurait
aurions
auriez
auraient
avais
avait
avions
aviez
avaient
eut
eûmes
eûtes
eurent
aie
aies
ait
ayons
ayez
aient
eusse
eusses
eût
eussions
eussiez
eussent

               | Later additions (from Jean-Christophe Deschamps)
ceci           |  this
cela           |  that
celà           |  that
cet            |  this
cette          |  this
ici            |  here
ils            |  they
les            |  the (pl)
leurs          |  their (pl)
quel           |  which
quels          |  which
quelle         |  which
quelles        |  which
sans           |  without
soi            |  oneself

              p       p  xMPG�  xMPG�                           p   '/configs/_default/lang/stopwords_sv.txt  � | From svn.tartarus.org/snowball/trunk/website/algorithms/swedish/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"

 | A Swedish stop word list. Comments begin with vertical bar. Each stop
 | word is at the start of a line.

 | This is a ranked list (commonest to rarest) of stopwords derived from
 | a large text sample.

 | Swedish stop words occasionally exhibit homonym clashes. For example
 |  så = so, but also seed. These are indicated clearly below.

och            | and
det            | it, this/that
att            | to (with infinitive)
i              | in, at
en             | a
jag            | I
hon            | she
som            | who, that
han            | he
på             | on
den            | it, this/that
med            | with
var            | where, each
sig            | him(self) etc
för            | for
så             | so (also: seed)
till           | to
är             | is
men            | but
ett            | a
om             | if; around, about
hade           | had
de             | they, these/those
av             | of
icke           | not, no
mig            | me
du             | you
henne          | her
då             | then, when
sin            | his
nu             | now
har            | have
inte           | inte någon = no one
hans           | his
honom          | him
skulle         | 'sake'
hennes         | her
där            | there
min            | my
man            | one (pronoun)
ej             | nor
vid            | at, by, on (also: vast)
kunde          | could
något          | some etc
från           | from, off
ut             | out
när            | when
efter          | after, behind
upp            | up
vi             | we
dem            | them
vara           | be
vad            | what
över           | over
än             | than
dig            | you
kan            | can
sina           | his
här            | here
ha             | have
mot            | towards
alla           | all
under          | under (also: wonder)
någon          | some etc
eller          | or (else)
allt           | all
mycket         | much
sedan          | since
ju             | why
denna          | this/that
själv          | myself, yourself etc
detta          | this/that
åt             | to
utan           | without
varit          | was
hur            | how
ingen          | no
mitt           | my
ni             | you
bli            | to be, become
blev           | from bli
oss            | us
din            | thy
dessa          | these/those
några          | some etc
deras          | their
blir           | from bli
mina           | my
samma          | (the) same
vilken         | who, that
er             | you, your
sådan          | such a
vår            | our
blivit         | from bli
dess           | its
inom           | within
mellan         | between
sådant         | such a
varför         | why
varje          | each
vilka          | who, that
ditt           | thy
vem            | who
vilket         | who, that
sitta          | his
sådana         | such a
vart           | each
dina           | thy
vars           | whose
vårt           | our
våra           | our
ert            | your
era            | your
vilkas         | whose

              �       �  xMPHC  xMPHC                           �   '/configs/_default/lang/stopwords_fi.txt  o | From svn.tartarus.org/snowball/trunk/website/algorithms/finnish/stop.txt
 | This file is distributed under the BSD License.
 | See http://snowball.tartarus.org/license.php
 | Also see http://www.opensource.org/licenses/bsd-license.html
 |  - Encoding was converted to UTF-8.
 |  - This notice was added.
 |
 | NOTE: To use this file with StopFilterFactory, you must specify format="snowball"
 
| forms of BE

olla
olen
olet
on
olemme
olette
ovat
ole        | negative form

oli
olisi
olisit
olisin
olisimme
olisitte
olisivat
olit
olin
olimme
olitte
olivat
ollut
olleet

en         | negation
et
ei
emme
ette
eivät

|Nom   Gen    Acc    Part   Iness   Elat    Illat  Adess   Ablat   Allat   Ess    Trans
minä   minun  minut  minua  minussa minusta minuun minulla minulta minulle               | I
sinä   sinun  sinut  sinua  sinussa sinusta sinuun sinulla sinulta sinulle               | you
hän    hänen  hänet  häntä  hänessä hänestä häneen hänellä häneltä hänelle               | he she
me     meidän meidät meitä  meissä  meistä  meihin meillä  meiltä  meille                | we
te     teidän teidät teitä  teissä  teistä  teihin teillä  teiltä  teille                | you
he     heidän heidät heitä  heissä  heistä  heihin heillä  heiltä  heille                | they

tämä   tämän         tätä   tässä   tästä   tähän  tallä   tältä   tälle   tänä   täksi  | this
tuo    tuon          tuotä  tuossa  tuosta  tuohon tuolla  tuolta  tuolle  tuona  tuoksi | that
se     sen           sitä   siinä   siitä   siihen sillä   siltä   sille   sinä   siksi  | it
nämä   näiden        näitä  näissä  näistä  näihin näillä  näiltä  näille  näinä  näiksi | these
nuo    noiden        noita  noissa  noista  noihin noilla  noilta  noille  noina  noiksi | those
ne     niiden        niitä  niissä  niistä  niihin niillä  niiltä  niille  niinä  niiksi | they

kuka   kenen kenet   ketä   kenessä kenestä keneen kenellä keneltä kenelle kenenä keneksi| who
ketkä  keiden ketkä  keitä  keissä  keistä  keihin keillä  keiltä  keille  keinä  keiksi | (pl)
mikä   minkä minkä   mitä   missä   mistä   mihin  millä   miltä   mille   minä   miksi  | which what
mitkä                                                                                    | (pl)

joka   jonka         jota   jossa   josta   johon  jolla   jolta   jolle   jona   joksi  | who which
jotka  joiden        joita  joissa  joista  joihin joilla  joilta  joille  joina  joiksi | (pl)

| conjunctions

että   | that
ja     | and
jos    | if
koska  | because
kuin   | than
mutta  | but
niin   | so
sekä   | and
sillä  | for
tai    | or
vaan   | but
vai    | or
vaikka | although


| prepositions

kanssa  | with
mukaan  | according to
noin    | about
poikki  | across
yli     | over, across

| other

kun    | when
niin   | so
nyt    | now
itse   | self

              �       �  xMPH_  xMPH_                           �   */configs/_default/lang/hyphenations_ga.txt   |# Set of Irish hyphenations for StopFilter
# TODO: load this as a resource from the analyzer and sync it in build.xml
h
n
t
              P       P  xMPGl  xMPGl                           P   '/configs/_default/lang/stopwords_gl.txt  3# galican stopwords
a
aínda
alí
aquel
aquela
aquelas
aqueles
aquilo
aquí
ao
aos
as
así
á
ben
cando
che
co
coa
comigo
con
connosco
contigo
convosco
coas
cos
cun
cuns
cunha
cunhas
da
dalgunha
dalgunhas
dalgún
dalgúns
das
de
del
dela
delas
deles
desde
deste
do
dos
dun
duns
dunha
dunhas
e
el
ela
elas
eles
en
era
eran
esa
esas
ese
eses
esta
estar
estaba
está
están
este
estes
estiven
estou
eu
é
facer
foi
foron
fun
había
hai
iso
isto
la
las
lle
lles
lo
los
mais
me
meu
meus
min
miña
miñas
moi
na
nas
neste
nin
no
non
nos
nosa
nosas
noso
nosos
nós
nun
nunha
nuns
nunhas
o
os
ou
ó
ós
para
pero
pode
pois
pola
polas
polo
polos
por
que
se
senón
ser
seu
seus
sexa
sido
sobre
súa
súas
tamén
tan
te
ten
teñen
teño
ter
teu
teus
ti
tido
tiña
tiven
túa
túas
un
unha
unhas
uns
vos
vosa
vosas
voso
vosos
vós
              �       �  xMPH  xMPH                           �   /configs/_default/synonyms.txt  d# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#-----------------------------------------------------------------------
#some test synonym mappings unlikely to appear in real input text
aaafoo => aaabar
bbbfoo => bbbfoo bbbbar
cccfoo => cccbar cccbaz
fooaaa,baraaa,bazaaa

# Some synonym groups specific to this example
GB,gib,gigabyte,gigabytes
MB,mib,megabyte,megabytes
Television, Televisions, TV, TVs
#notice we use "gib" instead of "GiB" so any WordDelimiterGraphFilter coming
#after us won't split it into two words.

# Synonym mappings can be used for spelling correction too
pixima => pixma

              �       �  xMPHl  xMPHl                           �   /configs/_default/stopwords.txt  # Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
                       xMPF�  xMPF�                              
/zookeeper    ��������                                                               /zookeeper/config                                                   ����                   /zookeeper/quota    ��������                                                               	/overseer����                       xMPFj  xMPFj                          �   /overseer/queue-work����              �       �  xMPH�  xMPH�                           �    /overseer/collection-map-failure����                       xMPF�  xMPF�                              /overseer/async_ids����              	       	  xMPF�  xMPF�                           	   /overseer/collection-queue-work����              �       �  xMPH�  xMPH�                           �   "/overseer/collection-map-completed����                       xMPF�  xMPF�                               /overseer/collection-map-running����                       xMPFx  xMPFx                              /overseer/queue����              �       �  xMPH�  xMPH�                          �   /overseer/queue/qn-0000000002   k{
  "node_name":"127.0.1.1:8983_solr",
  "base_url":"http://127.0.1.1:8983/solr",
  "operation":"downnode"}              �       �  xMS�n  xMS�n                           �   /aliases.json����                       xMPF�  xMPF�                              /live_nodes����              
       
  xMPF�  xMPF�                          �   /collections����                       xMPF�  xMPF�                              /overseer_elect����              �       �  xMPH�  xMPH�                          �   /overseer_elect/election����              �       �  xMPH�  xMPH�                          �   /security.json   {}                       xMPF�  xMPF�                              /clusterstate.json   {}                       xMPF�  xMPF�                              /autoscaling����                       xMPF�  xMPF�                             /autoscaling/nodeAdded����                       xMPF�  xMPF�                              /autoscaling/nodeLost����                       xMPF�  xMPF�                          �   )/autoscaling/nodeLost/127.0.1.1:7574_solr   !{"timestamp":1616205047735273326}              �       �  xMS�  xMS�                           �   /autoscaling/triggerState����                       xMPF�  xMPF�                          �   0/autoscaling/triggerState/.scheduled_maintenance   {"lastRunAt":1616204810793}              �       �  xMPJ_  xMPJ_                           �   ,/autoscaling/triggerState/.auto_add_replicas   l{
  "lastLiveNodes":["127.0.1.1:8983_solr"],
  "nodeNameVsTimeRemoved":{"127.0.1.1:7574_solr":548104214881}}              �       �  xMPJp  xMS��                          �   /autoscaling/events����                       xMPF�  xMPF�                          �   */autoscaling/events/.scheduled_maintenance����              �       �  xMPJK  xMPJK                           �   &/autoscaling/events/.auto_add_replicas����              �       �  xMPJ_  xMPJ_                           �   /autoscaling.json  9{
  "triggers":{
    ".auto_add_replicas":{
      "name":".auto_add_replicas",
      "event":"nodeLost",
      "waitFor":120,
      "enabled":true,
      "actions":[
        {
          "name":"auto_add_replicas_plan",
          "class":"solr.AutoAddReplicasPlanAction"},
        {
          "name":"execute_plan",
          "class":"solr.ExecutePlanAction"}]},
    ".scheduled_maintenance":{
      "name":".scheduled_maintenance",
      "event":"scheduled",
      "startTime":"NOW",
      "every":"+1DAY",
      "enabled":true,
      "actions":[
        {
          "name":"inactive_shard_plan",
          "class":"solr.InactiveShardPlanAction"},
        {
          "name":"inactive_markers_plan",
          "class":"solr.InactiveMarkersPlanAction"},
        {
          "name":"execute_plan",
          "class":"solr.ExecutePlanAction"}]}},
  "listeners":{
    ".auto_add_replicas.system":{
      "beforeAction":[],
      "afterAction":[],
      "stage":[
        "STARTED",
        "ABORTED",
        "SUCCEEDED",
        "FAILED",
        "BEFORE_ACTION",
        "AFTER_ACTION",
        "IGNORED"],
      "trigger":".auto_add_replicas",
      "class":"org.apache.solr.cloud.autoscaling.SystemLogListener"},
    ".scheduled_maintenance.system":{
      "beforeAction":[],
      "afterAction":[],
      "stage":[
        "STARTED",
        "ABORTED",
        "SUCCEEDED",
        "FAILED",
        "BEFORE_ACTION",
        "AFTER_ACTION",
        "IGNORED"],
      "trigger":".scheduled_maintenance",
      "class":"org.apache.solr.cloud.autoscaling.SystemLogListener"}},
  "properties":{}}                     �  xMPF�  xMPI�                             /    ��n�   /       �      (�ƺ�    [�v)   /