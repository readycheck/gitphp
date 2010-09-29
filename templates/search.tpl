{*
 *  search.tpl
 *  gitphp: A PHP git repository browser
 *  Component: Search view template
 *
 *  Copyright (C) 2009 Christopher Han <xiphux@gmail.com>
 *}

{include file='header.tpl'}

{* Nav *}
<div class="page_nav">
  {include file='nav.tpl' logcommit=$commit treecommit=$commit}
  <br />
  {if $page > 0}
    <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=search&h={$commit->GetHash()}&s={$search}&st={$searchtype}">{$resources->GetResource('first')}</a>
  {else}
    {$resources->GetResource('first')}
  {/if}
    &sdot; 
  {if $page > 0}
    <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=search&h={$commit->GetHash()}&s={$search}&st={$searchtype}{if $page > 1}&pg={$page-1}{/if}" accesskey="p" title="Alt-p">{$resources->GetResource('prev')}</a>
  {else}
    {$resources->GetResource('prev')}
  {/if}
    &sdot; 
  {if $hasmore}
    <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=search&h={$commit->GetHash()}&s={$search}&st={$searchtype}&pg={$page+1}" accesskey="n" title="Alt-n">{$resources->GetResource('next')}</a>
  {else}
    {$resources->GetResource('next')}
  {/if}
  <br />
</div>

{include file='title.tpl' titlecommit=$commit}

<table cellspacing="0">
  {* Print each match *}
  {foreach from=$results item=result}
    <tr class="{cycle values="light,dark"}">
      <td title="{if $result->GetAge() > 60*60*24*7*2}{$result->GetAge()|agestring}{else}{$result->GetCommitterEpoch()|date_format:"%F"}{/if}"><em>{if $result->GetAge() > 60*60*24*7*2}{$result->GetCommitterEpoch()|date_format:"%F"}{else}{$result->GetAge()|agestring}{/if}</em></td>
      <td>
        <em>
	  {if $searchtype == 'author'}
	    {$result->GetAuthorName()|highlight:$search}
	  {elseif $searchtype == 'committer'}
	    {$result->GetCommitterName()|highlight:$search}
	  {else}
	    {$result->GetAuthorName()}
	  {/if}
        </em>
      </td>
      <td><a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=commit&h={$result->GetHash()}" class="list commitTip" {if strlen($result->GetTitle()) > 50}title="{$result->GetTitle()}"{/if}><strong>{$result->GetTitle(50)}</strong>
      {if $searchtype == 'commit'}
        {foreach from=$result->SearchComment($search) item=line name=match}
          <br />{$line|highlight:$search:50}
        {/foreach}
      {/if}
      </td>
      {assign var=resulttree value=$result->GetTree()}
      <td class="link"><a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=commit&h={$result->GetHash()}">{$resources->GetResource('commit')}</a> | <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=commitdiff&h={$result->GetHash()}">{$resources->GetResource('commitdiff')}</a> | <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=tree&h={$resulttree->GetHash()}&hb={$result->GetHash()}">{$resources->GetResource('tree')}</a> | <a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=snapshot&h={$result->GetHash()}">{$resources->GetResource('snapshot')}</a>
      </td>
    </tr>
  {/foreach}

  {if $hasmore}
    <tr>
      <td><a href="{$SCRIPT_NAME}?p={$project->GetProject()|urlencode}&a=search&h={$commit->GetHash()}&s={$search}&st={$searchtype}&pg={$page+1}" title="Alt-n">{$resources->GetResource('next')}</a></td>
    </tr>
  {/if}
</table>

{include file='footer.tpl'}

