<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Cms\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Cms\Service\PageServiceInterface;
use Base\Service\SettingsServiceInterface;

class IndexController extends AbstractActionController
{
	protected $pageService;
	protected $cmsSettings;
	protected $translator;
	
	/**
	 * preDispatch event of the page
	 * 
	 * (non-PHPdoc)
	 * @see Zend\Mvc\Controller.AbstractActionController::onDispatch()
	 */
	public function onDispatch(\Zend\Mvc\MvcEvent $e){
		$this->translator = $e->getApplication()->getServiceManager()->get('translator');
		
		return parent::onDispatch( $e );
	}
	
	public function __construct(PageServiceInterface $pageService, SettingsServiceInterface $settings)
	{
		$this->pageService = $pageService;
		$this->cmsSettings = $settings;
	}
	
	/**
	 * Get the list of the active and visible pages 
	 * 
	 * (non-PHPdoc)
	 * @see Zend\Mvc\Controller.AbstractActionController::indexAction()
	 */
    public function indexAction ()
    {
    	$page = $this->params()->fromRoute('page');
    	$ItemCountPerPage = $this->cmsSettings->getValueByParameter('Cms', 'postperpage');
    	
    	$records = $this->pageService->getActivePages();
    	foreach ($records as $record){
    		$data[] = $record;
    	}
    	
    	$paginator = new \Zend\Paginator\Paginator(new \Zend\Paginator\Adapter\ArrayAdapter($data));
    	$paginator->setItemCountPerPage($ItemCountPerPage);
    	$paginator->setCurrentPageNumber($page);
    	
    	$viewModel  = new ViewModel(array('paginator' => $paginator));
    	return $viewModel;
    }
    
    /**
     * Search the page by the name 
     */
    public function searchAction ()
    {
    	$result = array();
    	
    	$searchString = $this->params()->fromRoute('query');
    	
    	if (!empty($searchString)){
    		// get the page by its slug code
    		$pages = $this->pageService->search($searchString, $this->translator->getLocale());
    		if(1 < $pages->count()){
	    		foreach ($pages as $page){
	    			$result[] = $page->getSlug() . '|' . $page->getTitle();
	    		}
    		}
    		 	
    	}
    	
    	die(implode("\n", $result));
    }
    
    /**
     * Show the page selected by its slug code 
     */
    public function pageAction ()
    {
    	$slug = $this->params()->fromRoute('slug');
    	
    	if(empty($slug)){
    		return $this->redirect()->toRoute('home');
    	}

    	// get the page by its slug code
    	$page = $this->pageService->findByUri($slug, $this->translator->getLocale());

    	if($page){
    		
    		// get the parent page
    		$parent = $this->pageService->find($page->getParentId());
    		
    		// get the layout of the page
    		$layout = new \Cms\Model\Layout($page, $this->cmsSettings);

    		// get the template set for the page
    		$template = $layout->getTemplate();
	    	
    		// set the view for the page
    		$viewModel  = new ViewModel(array('page' => $page, 'parent' => $parent));
	    	$viewModel->setTemplate('cms/index/' . $template);
	    	
    	}else{
    		$this->flashMessenger()->setNamespace('danger')->addMessage(sprintf($this->translator->translate('The page with the slug "%s" has been not found!'), $slug));
    		$viewModel  = new ViewModel();
    		$viewModel->setTemplate('cms/index/notfound');
    	}
    	
    	return $viewModel;
    }
}
