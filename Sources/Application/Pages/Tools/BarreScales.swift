import Foundation
import WebUI

struct BarreScales: Document {
  var path: String? { "tools/barre-scales" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Barre Scales - Mac Long Tools")
  }

  var body: some Markup {
    Layout(
      path: "tools/barre-scales",
      title: "Barre Scales - Mac Long Tools",
      description:
        "Interactive guitar scales reference with chord progressions for learning major and minor barre patterns.",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Tools", url: "/tools"),
        Breadcrumb(title: "Barre Scales", url: "/tools/barre-scales"),
      ]
    ) {
      LayoutHeader(
        breadcrumbs: [
          Breadcrumb(title: "Mac Long", url: "/"),
          Breadcrumb(title: "Tools", url: "/tools"),
          Breadcrumb(title: "Barre Scales", url: "/tools/barre-scales"),
        ],
        toolControls: {
          [
            Button(
              onClick: "toggleProgressions()",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
              ],
              label: "Toggle progressions"
            ) {
              Icon(name: "layout-grid", classes: ["w-5", "h-5"])
            },

            Button(
              onClick: "showInfo()",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
              ],
              label: "Information"
            ) {
              Icon(name: "info", classes: ["w-5", "h-5"])
            },
          ]
        },
        emoji: "🎸"
      )

      Stack(classes: ["flex"]) {
        // Sidebar for chord progressions
        Aside(
          id: "progressions-sidebar",
          classes: [
            "fixed", "inset-y-0", "left-0", "top-0", "z-60", "w-full", "max-w-sm",
            "bg-white", "dark:bg-zinc-800", "border-r", "border-zinc-200", "rounded-md",
            "dark:border-zinc-700", "lg:static", "lg:z-auto", "lg:max-w-80",
            "lg:h-[616px]", "transform", "-translate-x-full", "transition-transform",
            "duration-300", "ease-out", "lg:translate-x-0",
          ]
        ) {
          Stack(classes: ["flex", "flex-col", "h-full", "rounded-md"]) {
            Stack(classes: ["p-4", "border", "border-zinc-200", "rounded-md", "dark:border-zinc-700", "flex-shrink-0"]) {
              Stack(classes: ["flex", "items-center", "justify-between", "mb-4"]) {
                Heading(.headline, "Chord Progressions", classes: ["text-lg", "font-semibold"])
                MarkupString(
                  content: """
                        <button onclick="hideProgressions()" class="lg:hidden p-1 text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    """
                )
              }

              // Color key
              Stack(classes: ["mb-4"]) {
                Heading(.body, "Selection Order", classes: ["text-sm", "font-medium", "mb-2"])
                Stack(id: "degree-colors", classes: ["grid", "grid-cols-2", "sm:grid-cols-4", "gap-2"])
              }
            }

            Stack(id: "progressions-list", classes: ["flex-1", "overflow-y-auto", "p-4", "space-y-4", "rounded-md", "min-h-0"])
          }
        }

        // Main content
        Stack(classes: ["flex-1", "flex", "flex-col", "transition-all", "duration-300", "ease-out"]) {
          Stack(classes: ["flex-1", "px-4"]) {
            Stack(classes: ["max-w-5xl", "mx-auto"]) {
              // Scale table
              Stack(classes: [
                "bg-white", "dark:bg-zinc-800", "rounded-lg", "shadow-sm", "border",
                "border-zinc-200", "dark:border-zinc-700", "mb-4", "overflow-hidden",
              ]) {
                // Mobile Card View
                Stack(id: "mobile-scale-view", classes: ["block", "md:hidden"])

                // Desktop Table View
                Stack(classes: ["hidden", "md:block", "overflow-x-auto", "min-w-0"]) {
                  MarkupString(
                    content: """
                          <table class="w-full">
                              <thead class="bg-zinc-50 dark:bg-zinc-700">
                                  <tr>
                                      <th class="px-4 py-3 text-center text-xs font-medium text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">Degree</th>
                                      <th class="px-4 py-3 text-center text-xs font-medium text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">Note</th>
                                      <th class="px-4 py-3 text-center text-xs font-medium text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">Quality</th>
                                      <th class="px-4 py-3 text-left text-xs font-medium text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">All Positions</th>
                                  </tr>
                              </thead>
                              <tbody id="scale-table-body" class="divide-y divide-gray-200 dark:divide-gray-700">
                              </tbody>
                          </table>
                      """
                  )
                }
              }

              // Controls
              Stack(classes: [
                "bg-white", "dark:bg-zinc-800", "rounded-lg", "shadow-sm", "border",
                "border-zinc-200", "dark:border-zinc-700", "p-4",
              ]) {
                Stack(classes: ["grid", "grid-cols-1", "md:grid-cols-2", "gap-6"]) {
                  // Scale Type
                  Stack {
                    Text("Scale Type", classes: ["block", "text-sm", "font-medium", "mb-3"])
                    Stack(classes: ["flex", "space-x-2"]) {
                      Button(
                        "Major",
                        onClick: "setScaleType('major')",
                        id: "major-btn",
                        classes: [
                          "px-4", "py-2", "rounded-lg", "transition-colors", "font-medium",
                          "bg-teal-600", "text-white",
                        ]
                      )
                      Button(
                        "Minor",
                        onClick: "setScaleType('minor')",
                        id: "minor-btn",
                        classes: [
                          "px-4", "py-2", "rounded-lg", "transition-colors", "font-medium",
                          "bg-gray-100", "dark:bg-zinc-600", "text-zinc-700", "dark:text-zinc-300",
                        ]
                      )
                    }
                  }

                  // Root Note
                  Stack {
                    Text("Root Note", classes: ["block", "text-sm", "font-medium", "mb-3"])
                    Stack(
                      id: "note-buttons",
                      classes: ["grid", "grid-cols-3", "sm:grid-cols-4", "md:grid-cols-6", "gap-2"]
                    )
                  }
                }
              }
            }
          }
        }
      }

      // Info Modal
      MarkupString(
        content: """
              <div id="info-modal" class="fixed inset-0 bg-black bg-opacity-10 flex items-center justify-center p-4 z-50 hidden" onclick="hideInfo()">
                  <div class="bg-white dark:bg-zinc-800 rounded-lg max-w-2xl w-full p-6" onclick="event.stopPropagation()">
                      <div class="flex items-center justify-between mb-4">
                          <h3 class="text-xl font-semibold text-zinc-900 dark:text-zinc-100">How to Use the Barre Scales Tool</h3>
                          <button onclick="hideInfo()" class="text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200">
                              <i data-lucide="x" class="w-6 h-6"></i>
                          </button>
                      </div>
                      <div class="text-zinc-700 dark:text-zinc-300 space-y-4">
                          <p><strong>Getting Started:</strong> Choose your scale type (Major or Minor) and root note using the controls at the bottom. The table will update to show all seven degrees of the scale with their corresponding barre chord positions.</p>
                          <p><strong>Selecting Degrees:</strong> Click on any row in the table to select that degree. Selected degrees are highlighted and numbered in order of selection. This helps you build chord progressions step by step.</p>
                          <p><strong>Chord Progressions:</strong> Use the sidebar (toggle with the grid icon) to explore common chord progressions. Click any progression to automatically select the corresponding degrees in the correct order.</p>
                          <p><strong>Barre Positions:</strong> Each degree shows multiple barre chord shapes with fret positions. The letters in parentheses indicate the root string: (E) = E-string shapes, (A) = A-string shapes, (D) = D-string shapes.</p>
                          <p><strong>Color Coding:</strong> Chord qualities are color-coded (Major = green, Minor = blue, Diminished = red).</p>
                      </div>
                  </div>
              </div>
          """
      )

      Script(content: {
        """
        // Barre Scales App
        (function() {
            let state = {
                sidebarOpen: false,
                showInfoModal: false,
                scaleType: 'major',
                rootNote: 'C',
                selectedDegrees: [],
                degrees: [1, 2, 3, 4, 5, 6, 7],
                notes: ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'],
                currentScale: null
            };

            const progressions = [
                {
                    name: 'The Eternal Circle',
                    formula: 'I - V - vi - IV',
                    degrees: '1 - 5 - 6 - 4',
                    description: 'The heartbeat of popular music. Creates natural resolution while keeping listeners suspended in familiar comfort.',
                    examples: '"Let It Be", "Don\\'t Stop Believin\\'"'
                },
                {
                    name: 'The Descent',
                    formula: 'vi - IV - I - V',
                    degrees: '6 - 4 - 1 - 5',
                    description: 'Starting in minor territory, falling toward home. Creates emotional weight through gravitational pull downward.',
                    examples: '"Creep", "With or Without You"'
                },
                {
                    name: 'The Jazz Standard',
                    formula: 'ii - V - I',
                    degrees: '2 - 5 - 1',
                    description: 'The lingua franca of jazz. Simple, sophisticated, endlessly renewable. Tension builds and releases naturally.',
                    examples: '"Autumn Leaves", "All The Things You Are"'
                },
                {
                    name: 'The Folk Circle',
                    formula: 'I - vi - ii - V',
                    degrees: '1 - 6 - 2 - 5',
                    description: 'Cyclical and storytelling. Each chord leans into the next like verses in an ancient ballad.',
                    examples: '"Stand By Me", "Blue Moon"'
                },
                {
                    name: 'The 50s Progression',
                    formula: 'I - vi - IV - V',
                    degrees: '1 - 6 - 4 - 5',
                    description: 'The sound of classic rock and roll. Cheerful and nostalgic, this progression dominated the doo-wop era and remains timeless.',
                    examples: '"Earth Angel", "Blue Moon"'
                },
                {
                    name: 'The Classic Turnaround',
                    formula: 'I - IV - V - I',
                    degrees: '1 - 4 - 5 - 1',
                    description: 'The most fundamental progression in Western music. Strong departure from home, building tension, then perfect resolution back to the tonic.',
                    examples: '"Louie Louie", "Wild Thing"'
                }
            ];

            // Scale formulas and chord qualities
            const majorScaleIntervals = [0, 2, 4, 5, 7, 9, 11];
            const minorScaleIntervals = [0, 2, 3, 5, 7, 8, 10];
            const majorChordQualities = ['Major', 'Minor', 'Minor', 'Major', 'Major', 'Minor', 'Diminished'];
            const minorChordQualities = ['Minor', 'Diminished', 'Major', 'Minor', 'Minor', 'Major', 'Major'];

            // Global functions
            window.toggleProgressions = function() {
                state.sidebarOpen = !state.sidebarOpen;
                const sidebar = document.getElementById('progressions-sidebar');
                if (sidebar) {
                    if (state.sidebarOpen) {
                        sidebar.classList.remove('-translate-x-full');
                        sidebar.classList.add('translate-x-0');
                    } else {
                        sidebar.classList.remove('translate-x-0');
                        sidebar.classList.add('-translate-x-full');
                    }
                }
            };

            window.hideProgressions = function() {
                state.sidebarOpen = false;
                const sidebar = document.getElementById('progressions-sidebar');
                if (sidebar) {
                    sidebar.classList.remove('translate-x-0');
                    sidebar.classList.add('-translate-x-full');
                }
            };

            window.showInfo = function() {
                state.showInfoModal = true;
                const modal = document.getElementById('info-modal');
                if (modal) modal.classList.remove('hidden');
            };

            window.hideInfo = function() {
                state.showInfoModal = false;
                const modal = document.getElementById('info-modal');
                if (modal) modal.classList.add('hidden');
            };

            window.setScaleType = function(type) {
                state.scaleType = type;
                updateScaleButtons();
                updateScale();
            };

            window.setRootNote = function(note) {
                state.rootNote = note;
                updateNoteButtons();
                updateScale();
            };

            window.toggleDegree = function(index) {
                if (state.selectedDegrees.includes(index)) {
                    state.selectedDegrees = state.selectedDegrees.filter(d => d !== index);
                } else {
                    state.selectedDegrees.push(index);
                }
                renderScale();
            };

            window.selectProgression = function(progression) {
                const degreeNumbers = progression.degrees.split(' - ').map(d => parseInt(d.trim()) - 1);
                state.selectedDegrees = [...degreeNumbers];
                renderScale();
                hideProgressions();
            };

            // Helper functions
            function getNoteFromOffset(rootNote, semitones, scaleType) {
                const noteIndex = state.notes.indexOf(rootNote);
                const targetIndex = (noteIndex + semitones) % 12;
                let resultNote = state.notes[targetIndex];
                
                if (scaleType === 'minor') {
                    const enharmonicMap = {
                        'C#': 'D♭', 'D#': 'E♭', 'F#': 'G♭', 'G#': 'A♭', 'A#': 'B♭'
                    };
                    if (enharmonicMap[resultNote]) {
                        resultNote = enharmonicMap[resultNote];
                    }
                }
                return resultNote;
            }

            function getBarrePositions(note) {
                const normalizedNote = note.replace('♯', '#').replace('♭', 'b');
                const flatToSharpMap = { Db: 'C#', Eb: 'D#', Gb: 'F#', Ab: 'G#', Bb: 'A#' };
                const lookupNote = flatToSharpMap[normalizedNote] || normalizedNote;
                const chromaticIndex = state.notes.indexOf(lookupNote);

                const basePositions = [
                    { C: '3rd (A)', A: '3rd (A)', G: '10th (E)', E: '8th (E)', D: '10th (D)' },
                    { C: '4th (A)', A: '4th (A)', G: '11th (E)', E: '9th (E)', D: '11th (D)' },
                    { C: '5th (A)', A: '5th (A)', G: '12th (E)', E: '10th (E)', D: '12th (D)' },
                    { C: '6th (A)', A: '6th (A)', G: '1st (E)', E: '11th (E)', D: '1st (D)' },
                    { C: '7th (A)', A: '7th (A)', G: '2nd (E)', E: '12th (E)', D: '2nd (D)' },
                    { C: '8th (A)', A: '8th (A)', G: '3rd (E)', E: '1st (E)', D: '3rd (D)' },
                    { C: '9th (A)', A: '9th (A)', G: '4th (E)', E: '2nd (E)', D: '4th (D)' },
                    { C: '10th (A)', A: '10th (A)', G: '5th (E)', E: '3rd (E)', D: '5th (D)' },
                    { C: '11th (A)', A: '11th (A)', G: '6th (E)', E: '4th (E)', D: '6th (D)' },
                    { C: '12th (A)', A: '12th (A)', G: '7th (E)', E: '5th (E)', D: '7th (D)' },
                    { C: '1st (A)', A: '1st (A)', G: '8th (E)', E: '6th (E)', D: '8th (D)' },
                    { C: '2nd (A)', A: '2nd (A)', G: '9th (E)', E: '7th (E)', D: '9th (D)' }
                ];
                return basePositions[chromaticIndex] || basePositions[0];
            }

            function generateScale(scaleType, rootNote) {
                const intervals = scaleType === 'major' ? majorScaleIntervals : minorScaleIntervals;
                const qualities = scaleType === 'major' ? majorChordQualities : minorChordQualities;

                const degrees = intervals.map((interval, index) => {
                    const note = getNoteFromOffset(rootNote, interval, scaleType);
                    return {
                        degree: ['1st', '2nd', '3rd', '4th', '5th', '6th', '7th'][index],
                        note: note,
                        positions: getBarrePositions(note),
                        quality: qualities[index]
                    };
                });

                return {
                    name: `${rootNote} ${scaleType.charAt(0).toUpperCase() + scaleType.slice(1)}`,
                    degrees: degrees
                };
            }

            function updateScale() {
                state.currentScale = generateScale(state.scaleType, state.rootNote);
                renderScale();
            }

            function updateScaleButtons() {
                const majorBtn = document.getElementById('major-btn');
                const minorBtn = document.getElementById('minor-btn');
                
                if (majorBtn && minorBtn) {
                    if (state.scaleType === 'major') {
                        majorBtn.className = majorBtn.className.replace(/bg-gray-\\d+|bg-zinc-\\d+|text-zinc-\\d+/g, '') + ' bg-teal-600 text-white';
                        minorBtn.className = minorBtn.className.replace(/bg-teal-\\d+|text-white/g, '') + ' bg-gray-100 dark:bg-zinc-600 text-zinc-700 dark:text-zinc-300';
                    } else {
                        minorBtn.className = minorBtn.className.replace(/bg-gray-\\d+|bg-zinc-\\d+|text-zinc-\\d+/g, '') + ' bg-teal-600 text-white';
                        majorBtn.className = majorBtn.className.replace(/bg-teal-\\d+|text-white/g, '') + ' bg-gray-100 dark:bg-zinc-600 text-zinc-700 dark:text-zinc-300';
                    }
                }
            }

            function updateNoteButtons() {
                const container = document.getElementById('note-buttons');
                if (!container) return;

                container.innerHTML = state.notes.map(note => `
                    <button onclick="setRootNote('${note}')" 
                        class="px-2 py-2 rounded-lg transition-colors font-medium text-sm ${
                            state.rootNote === note 
                                ? 'bg-teal-600 text-white' 
                                : 'bg-gray-100 dark:bg-zinc-600 text-zinc-700 dark:text-zinc-300 hover:bg-gray-200 dark:hover:bg-gray-500'
                        }">
                        ${note.replace('#', '♯')}
                    </button>
                `).join('');
            }

            function renderScale() {
                if (!state.currentScale) return;

                const tableBody = document.getElementById('scale-table-body');
                if (tableBody) {
                    tableBody.innerHTML = state.currentScale.degrees.map((degree, index) => {
                        const isSelected = state.selectedDegrees.includes(index);
                        const selectionOrder = state.selectedDegrees.indexOf(index) + 1;
                        
                        const qualityClass = degree.quality === 'Major' ? 'chord-major' :
                                           degree.quality === 'Minor' ? 'chord-minor' : 'chord-diminished';

                        const positionsHtml = Object.entries(degree.positions).map(([shape, position]) => 
                            `<span class="inline-flex items-center justify-center px-2 py-1 text-xs font-medium bg-gray-100 dark:bg-zinc-600 text-gray-800 dark:text-zinc-200 rounded text-center whitespace-nowrap">
                                ${shape}: ${position}
                            </span>`
                        ).join('');

                        return `
                            <tr onclick="toggleDegree(${index})" class="cursor-pointer hover:bg-zinc-50 dark:hover:bg-zinc-700 transition-colors ${isSelected ? 'bg-blue-50 dark:bg-blue-900/20' : ''}">
                                <td class="px-4 py-4 text-center">
                                    <div class="flex items-center justify-center space-x-2">
                                        <div class="degree-${index + 1} w-6 h-6 border border-zinc-300 dark:border-zinc-600 flex items-center justify-center text-sm font-semibold text-gray-900">
                                            ${isSelected ? selectionOrder : ''}
                                        </div>
                                        <span class="text-sm font-medium text-zinc-900 dark:text-zinc-100">${degree.degree}</span>
                                    </div>
                                </td>
                                <td class="px-4 py-4 text-center">
                                    <span class="text-sm font-semibold text-zinc-900 dark:text-zinc-100">${degree.note}</span>
                                </td>
                                <td class="px-4 py-4 text-center">
                                    <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-full text-gray-900 ${qualityClass}">${degree.quality}</span>
                                </td>
                                <td class="px-4 py-4">
                                    <div class="flex flex-wrap gap-1">${positionsHtml}</div>
                                </td>
                            </tr>
                        `;
                    }).join('');
                }

                // Mobile card view rendering
                const mobileView = document.getElementById('mobile-scale-view');
                if (mobileView) {
                    mobileView.innerHTML = state.currentScale.degrees.map((degree, index) => {
                        const isSelected = state.selectedDegrees.includes(index);
                        const selectionOrder = state.selectedDegrees.indexOf(index) + 1;
                        
                        const qualityClass = degree.quality === 'Major' ? 'chord-major' :
                                           degree.quality === 'Minor' ? 'chord-minor' : 'chord-diminished';

                        const positionsHtml = Object.entries(degree.positions).map(([shape, position]) => 
                            `<span class="inline-block px-2 py-1 text-xs font-medium bg-gray-100 dark:bg-zinc-600 text-gray-800 dark:text-zinc-200 mr-1 mb-1">
                                ${shape}: ${position}
                            </span>`
                        ).join('');

                        return `
                            <div onclick="toggleDegree(${index})" class="bg-white dark:bg-zinc-700 rounded-lg border border-zinc-200 dark:border-zinc-600 p-4 mb-3 cursor-pointer hover:bg-zinc-50 dark:hover:bg-zinc-600 transition-colors ${isSelected ? 'ring-2 ring-blue-500 dark:ring-blue-400' : ''}">
                                <div class="flex items-center justify-between mb-3">
                                    <div class="flex items-center space-x-3">
                                        <div class="degree-${index + 1} w-8 h-8 rounded border border-zinc-300 dark:border-zinc-600 flex items-center justify-center text-sm font-semibold text-gray-900">
                                            ${isSelected ? selectionOrder : ''}
                                        </div>
                                        <div>
                                            <div class="text-sm font-medium text-zinc-500 dark:text-zinc-400">${degree.degree}</div>
                                            <div class="text-lg font-semibold text-zinc-900 dark:text-zinc-100">${degree.note}</div>
                                        </div>
                                    </div>
                                    <span class="inline-flex items-center px-3 py-1 text-sm font-medium rounded-full text-gray-900 ${qualityClass}">${degree.quality}</span>
                                </div>
                                <div class="space-y-2">
                                    <div class="text-xs font-medium text-zinc-500 dark:text-zinc-400 uppercase tracking-wider">Barre Positions</div>
                                    <div class="flex flex-wrap">${positionsHtml}</div>
                                </div>
                            </div>
                        `;
                    }).join('');
                }
            }

            function renderProgressions() {
                const container = document.getElementById('progressions-list');
                if (!container) return;

                container.innerHTML = progressions.map((progression, index) => `
                    <div onclick="selectProgression(progressions[${index}])" 
                         class="bg-zinc-50 dark:bg-zinc-700 rounded-lg p-4 border border-zinc-200 dark:border-zinc-600 cursor-pointer hover:bg-zinc-100 dark:hover:bg-zinc-600 transition-colors">
                        <h4 class="font-semibold text-zinc-900 dark:text-zinc-100 mb-2">${progression.name}</h4>
                        <div class="text-sm text-zinc-600 dark:text-zinc-300 mb-1">${progression.formula}</div>
                        <div class="text-sm text-zinc-500 dark:text-zinc-400 mb-2">${progression.degrees}</div>
                        <p class="text-xs text-zinc-600 dark:text-zinc-400 mb-2">${progression.description}</p>
                        <div class="text-xs text-zinc-500 dark:text-zinc-500">${progression.examples}</div>
                        <div class="mt-2 text-xs text-teal-600 dark:text-teal-400 font-medium">
                            Click to select this progression →
                        </div>
                    </div>
                `).join('');
            }

            function renderDegreeColors() {
                const container = document.getElementById('degree-colors');
                if (!container) return;

                container.innerHTML = state.degrees.map((degree, index) => `
                    <div class="flex items-center space-x-1 text-xs">
                        <div class="degree-${index + 1} w-4 h-4 rounded border border-zinc-300 dark:border-zinc-600 flex items-center justify-center">
                            <span class="text-gray-900 font-bold ${state.selectedDegrees.includes(index) ? '' : 'hidden'}">
                                ${state.selectedDegrees.indexOf(index) + 1}
                            </span>
                        </div>
                        <span class="text-zinc-600 dark:text-zinc-400">
                            ${degree}${index === 0 ? 'st' : index === 1 ? 'nd' : index === 2 ? 'rd' : 'th'}
                        </span>
                    </div>
                `).join('');
            }

            // Initialize app
            function init() {
                updateScale();
                updateNoteButtons();
                renderProgressions();
                renderDegreeColors();
                
                setTimeout(() => {
                    if (window.lucide) lucide.createIcons();
                }, 100);
            }

            // Initialize when DOM is ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', init);
            } else {
                init();
            }
            
            // Add custom CSS for degree colors
            const customCSS = `
                .chord-major { background-color: #86efac; }
                .chord-minor { background-color: #93c5fd; }  
                .chord-diminished { background-color: #fca5a5; }
                
                .degree-1 { background-color: #fca5a5; }
                .degree-2 { background-color: #fed7aa; }
                .degree-3 { background-color: #fef3c7; }
                .degree-4 { background-color: #86efac; }
                .degree-5 { background-color: #a7f3d0; }
                .degree-6 { background-color: #93c5fd; }
                .degree-7 { background-color: #d8b4fe; }
            `;
            
            const styleSheet = document.createElement('style');
            styleSheet.textContent = customCSS;
            document.head.appendChild(styleSheet);
        })();
        """
      })
    }
  }
}
