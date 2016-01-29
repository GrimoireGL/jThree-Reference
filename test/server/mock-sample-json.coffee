module.exports =
  name: 'typedoc'
  children: [
      id: 1
      name: '"dir1/file1"'
      kindString: 'External modules'
      children: [
          id: 2
          name: 'class1'
          kindString: 'Class'
          comment:
            shortText: "sample comment"
          children:　[
              id: 3
              name: 'method1'
              kindString: 'Method'
              comment:
                shortText: "sample comment"
            ,
              id: 4
              name: 'prop1'
              kindString: 'Property'
              comment:
                shortText: "sample comment"
          ]
          groups: [
              title: 'Methods'
              children: [3]
            ,
              title: 'Properties'
              children: [4]
          ]
      ]
      groups: [
          title: 'Classes'
          children: [2]
      ]
    ,
      id: 5
      name: '"dir1/dir1_2/file2"'
      kindString: 'External modules'
      children: [
          id: 6
          name: 'class2'
          kindString: 'Class'
          comment:
            shortText: "sample comment"
          children: [
              id: 7
              name: 'constructor1'
              kindString: 'Constructor'
              comment:
                shortText: "sample comment"
          ]
          groups: [
              title: 'Constructors'
              children: [7]
          ]
      ]
      groups: [
          title: 'Classes'
          children: [6]
      ]
  ]
  groups: [
      title: 'External modules'
      children: [1, 2]
  ]
