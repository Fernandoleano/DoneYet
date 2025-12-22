import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "configField", "properties"]

  connect() {
    this.blocks = []
    this.selectedBlock = null
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    const templates = this.element.querySelectorAll('.block-template')
    
    templates.forEach(template => {
      template.setAttribute('draggable', 'true')
      
      template.addEventListener('dragstart', (e) => {
        e.dataTransfer.setData('blockType', template.dataset.blockType)
        e.dataTransfer.setData('blockSubtype', template.dataset.blockSubtype)
        e.dataTransfer.setData('blockHtml', template.outerHTML)
      })
    })

    this.canvasTarget.addEventListener('dragover', (e) => {
      e.preventDefault()
    })

    this.canvasTarget.addEventListener('drop', (e) => {
      e.preventDefault()
      this.handleDrop(e)
    })
  }

  handleDrop(e) {
    const blockType = e.dataTransfer.getData('blockType')
    const blockSubtype = e.dataTransfer.getData('blockSubtype')
    const blockHtml = e.dataTransfer.getData('blockHtml')
    
    const block = {
      id: Date.now(),
      type: blockType,
      subtype: blockSubtype,
      config: {}
    }
    
    this.blocks.push(block)
    
    // Create visual block
    const blockEl = document.createElement('div')
    blockEl.innerHTML = blockHtml
    blockEl.classList.add('mb-4', 'cursor-pointer')
    blockEl.dataset.blockId = block.id
    blockEl.addEventListener('click', () => this.selectBlock(block, blockEl))
    
    const dropZone = this.canvasTarget.querySelector('.min-h-full')
    dropZone.appendChild(blockEl)
    
    this.updateConfig()
  }

  selectBlock(block, element) {
    this.selectedBlock = block
    
    // Highlight selected
    this.canvasTarget.querySelectorAll('[data-block-id]').forEach(el => {
      el.classList.remove('ring-2', 'ring-white')
    })
    element.classList.add('ring-2', 'ring-white')
    
    // Show properties
    this.propertiesTarget.innerHTML = this.getPropertiesHTML(block)
  }

  getPropertiesHTML(block) {
    let configForm = '<p class="text-sm text-gray-500">No configuration needed</p>'
    
    if (block.subtype === 'schedule') {
      configForm = `
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Frequency</label>
          <select class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="frequency">
            <option value="daily">Daily</option>
            <option value="weekly">Weekly</option>
            <option value="monthly">Monthly</option>
          </select>
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Time</label>
          <input type="time" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="time">
        </div>
      `
    } else if (block.subtype === 'send_reminder') {
      configForm = `
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Reminder Message</label>
          <textarea class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" rows="3" placeholder="Don't forget to..." data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="message"></textarea>
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Remind me in (hours)</label>
          <input type="number" min="1" value="24" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="hours">
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Send via</label>
          <select class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="channel">
            <option value="email">Email</option>
            <option value="slack">Slack</option>
            <option value="both">Both</option>
          </select>
        </div>
      `
    } else if (block.subtype === 'create_meeting') {
      configForm = `
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Meeting Title</label>
          <input type="text" placeholder="Weekly Standup" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="title">
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Duration (minutes)</label>
          <input type="number" min="15" value="30" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="duration">
        </div>
      `
    } else if (block.subtype === 'send_email') {
      configForm = `
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Subject</label>
          <input type="text" placeholder="Email subject" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="subject">
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Message</label>
          <textarea class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" rows="4" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="message"></textarea>
        </div>
      `
    } else if (block.subtype === 'send_slack') {
      configForm = `
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Channel</label>
          <input type="text" placeholder="#general" class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="channel">
        </div>
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Message</label>
          <textarea class="w-full bg-gray-800 border border-gray-700 rounded px-3 py-2 text-white text-sm" rows="4" data-action="change->automation-builder#updateBlockConfig" data-block-id="${block.id}" data-config-key="message"></textarea>
        </div>
      `
    }
    
    return `
      <h3 class="text-sm font-bold text-white mb-4 uppercase">Properties</h3>
      <div class="space-y-4">
        <div>
          <label class="block text-xs font-medium text-gray-400 mb-2">Block Type</label>
          <p class="text-white">${block.type} - ${block.subtype}</p>
        </div>
        ${configForm}
        <button type="button" class="w-full px-4 py-2 bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/20 rounded-lg transition text-sm" data-action="click->automation-builder#deleteBlock" data-block-id="${block.id}">Delete Block</button>
      </div>
    `
  }

  updateBlockConfig(event) {
    const blockId = parseInt(event.target.dataset.blockId)
    const key = event.target.dataset.configKey
    const value = event.target.value
    
    const block = this.blocks.find(b => b.id === blockId)
    if (block) {
      block.config[key] = value
      this.updateConfig()
    }
  }

  deleteBlock(event) {
    const blockId = parseInt(event.target.dataset.blockId)
    this.blocks = this.blocks.filter(b => b.id !== blockId)
    
    const element = this.canvasTarget.querySelector(`[data-block-id="${blockId}"]`)
    if (element) element.remove()
    
    this.propertiesTarget.innerHTML = '<h3 class="text-sm font-bold text-white mb-4 uppercase">Properties</h3><div class="text-center text-gray-500 py-8"><p class="text-sm">Select a block to configure</p></div>'
    
    this.updateConfig()
  }

  updateConfig() {
    const config = {
      blocks: this.blocks
    }
    this.configFieldTarget.value = JSON.stringify(config)
  }
}
